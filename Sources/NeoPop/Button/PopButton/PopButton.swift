//
//  PopButton.swift
//  NeoPop
//
//  Copyright 2022 Dreamplug Technologies Private Limited
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

/// This is a type of button which gives 3D click effect.
///
/// It renders the 3D effect using two PopViews.
/// The structure and the behaviour of a PopButton mainly depends on two entities which are ``EdgeDirection`` & ``PopButton/Position``.
///
/// - To configure the appearance of the button
///
/// ```swift
/// let popButton = PopButton()
///
/// button.configurePopButton(
///     withModel: PopButton.Model(
///         direction: .bottomRight
///         position: .bottomRight,
///         backgroundColor: ColorHelper.popWhite500
///     )
/// )
/// ```
///
/// - To configure the content of the button
///
/// ```swift
/// button.configureButtonContent(
///     withModel: PopButtonContainerView.Model(
///         title: "Click here",
///         leftImage: UIImage(named: "left_arrow"),
///         leftImageTintColor: UIColor.white,
///         contentLeftRightInset: 10
///     )
/// )
/// ```
///
/// - To start the shimmer
///
/// ```swift
/// button.startShimmerAnimation()
/// ```
///
open class PopButton: UIButton {
    public enum CornerShape {
        case rightToBottomLeftCorner(usedHorizontally: Bool) // right side will have vertical edge and bottom has horizontal edge. similarly for other edges too.
        case rightToTopLeftCorner(usedHorizontally: Bool)
        case leftToBottomRightCorner(usedHorizontally: Bool)
        case leftToTopRightCorner(usedHorizontally: Bool)
        case none
    }

    private let normalPopView = PopView()
    private let selectedPopView = PopView()
    private let buttonContentHolderView = UIView()
    private let buttonContentView = PopContentView()

    private let cornerEdgeView = UIView()
    private lazy var cornerEdgeLineShape = CAShapeLayer()
    private lazy var cornerViewMask = CAShapeLayer()

    private var selectedPopViewConstraints: EdgeConstraints?
    private var normalPopViewConstraints: EdgeConstraints?
    private var buttonContentHolderViewConstraints: EdgeConstraints?
    private var buttonContentViewConstraints: EdgeConstraints?

    private var cornerEdgeViewHeightConstraint: NSLayoutConstraint?

    private var isShimmerActive: Bool = false
    private var shimmerRepeatCount = Float.infinity
    private var shimmerStartDelay: CGFloat = 0

    private var buttonContentsViewBoundsObserver: NSKeyValueObservation?
    private var shimmerDelayTimer: Timer?

    private var staticBorder = PopContentLayer()

    private let pressAnimationDuration: Double = PopConfiguration.PopButton.pressDuration

    private var isInTransition: Bool = false
    private weak var customContainer: PopButtonCustomContainerDrawable?

    private var sendTouchEvent: (() -> Void)?

    private var currentFrame: CGRect?

    var staticBorderColors: (horizontal: UIColor?, vertical: UIColor?)?

    var drawingManager: PopButtonDrawable.Type = BottomRightButtonDrawManager.self {
        didSet {
            buttonContentView.drawingManager = drawingManager
        }
    }

    var model: PopButton.Model = PopButton.Model(position: .bottomRight, backgroundColor: .clear, superViewColor: nil, parentContainerBGColor: nil, edgeLength: 0) {
        didSet {
            buttonContentView.config = model
        }
    }

    /// It defines the state of the button
    ///
    /// Default value is ``PopButton/State/unknown``
    ///
    /// refer ``PopButton/State`` for list of states
    open var buttonState: PopButton.State = .unknown {
        willSet {
            customContainer?.updateOnStateChange(state: newValue)
        }
    }

    /// Use this property to control the button click event.
    ///
    /// When it is `true`, `touchUpInside` event will be triggered after click animation ends, else it will be triggered immediately.
    ///
    /// Default value is `true`
    open var delayTouchEvents: Bool = true

    open override var isHighlighted: Bool {
        willSet {
            guard newValue != isHighlighted else { return }
            applyUIChangeOnAction(isHighlighted: newValue)
        }
    }

    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        let superCall = { super.sendAction(action, to: target, for: event) }

        guard delayTouchEvents else {
            superCall()
            return
        }
        if event?.firstTouchToControlEvent() == .touchUpInside {
            sendTouchEvent = superCall
        } else {
            superCall()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let presentFrame = currentFrame,
              presentFrame != frame else {
            return
        }

        currentFrame = frame

        switch buttonState { // Draw face of the button with button color. The normal/highlighted models will have center part hidden.
        case .disabled(let disabledStateWithOpacity):
            drawContentViewLayer(forDisabledState: !disabledStateWithOpacity)
        default:
            drawContentViewLayer()
        }
        drawStaticBorders() // Static borders at the base which will be immobile.
    }
}

public extension PopButton {

    /// Use this method to configure and update the appearance of the button.
    ///
    /// - Parameter model: the model which contains all the properties related to appearance of the ``PopButton``
    ///
    /// refer ``PopButton/Model`` for configurable properties.
    ///
    func configurePopButton(withModel model: PopButton.Model) {
        self.model = model

        drawingManager = normalStateEdgeDirection.drawingManager()
        setupEdgeCornerPop(model: model)
        selectedPopView.configurePopView(withModel: getHighlightedModel())
        normalPopView.configurePopView(withModel: getNormalModel())
        applyUIChangeOnAction(isHighlighted: isHighlighted, animate: false)
        setupContentView()
        currentFrame = frame
    }

    /// Use this method to configure the content of the button like `text`, `images`.
    ///
    /// - Parameter model: the model which configures the button content
    ///
    /// refer ``PopButtonContainerView/Model`` for configurable properties
    ///
    func configureButtonContent(withModel model: PopButtonContainerView.Model) {
        guard let container = customContainer as? PopButtonContainerView else { return }
        container.configureView(withModel: model)
    }

    /// Use this method to inject custom content view.
    /// it enables you to add label and imageViews of your choice
    ///
    /// - Parameter view: a view that conforms to ``PopButtonCustomContainerDrawable``
    ///
    /// refer ``PopButton/configureButtonContent(withModel:)`` to use existing content view
    ///
    /// refer ``PopButton/removeCustomContainer()`` to remove injected content view
    ///
    func setCustomContainerView(_ view: PopButtonCustomContainerDrawable) {
        customContainer = view
        buttonContentView.addSubview(view)
        view.fillSuperview()
    }

    /// Use this method remove custom content view which was inject using ``PopButton/setCustomContainerView(_:)``
    func removeCustomContainer() {
        customContainer?.removeFromSuperview()
    }

    /// Use this method to change the state of the button
    ///
    /// It internally updates the state of the button content too through ``PopButtonCustomContainerDrawable/updateOnStateChange(state:)``.
    ///
    /// Use the above method from the protocol to update the state of the button content
    ///
    /// - Parameter newState: new state of the button
    /// - Returns: it returns whether the new state is updated or not
    @discardableResult
    func changeButtonState(newState: PopButton.State) -> Bool {

        guard newState != buttonState else {
            return false
        }

        // Change from disabled to any state needs the default setups.
        if case .disabled(let disabledStateWithOpacity) = buttonState,
           case disabledStateWithOpacity = false {
            normalPopView.configurePopView(withModel: getNormalModel())
            drawContentViewLayer()
            drawStaticBorders()
        }

        // Update the alpha to 1.
        alpha = 1

        switch newState {
        case .pressed, .unknown:
            return false

        case .normal:
            isEnabled = true
            buttonState = newState
            return true

        case .loading:
            isEnabled = false
            buttonState = newState
            return true

        case .success:
            isEnabled = false
            buttonState = newState
            return true

        case .disabled(let disabledStateWithOpacity):
            isEnabled = false

            if disabledStateWithOpacity {
                alpha = 0.6
            } else {
                // Change button color
                normalPopView.configurePopView(withModel: getNormalModel(forDisabledState: true))
                drawContentViewLayer(forDisabledState: true)
                hideStaticBorder()
            }

            buttonState = newState
            return true
        }
    }
}

// MARK: Shimmer Methods
public extension PopButton {

    /// Use this method to start shimmer animation on the button.
    /// it highlights the button by moving from start to end continuously with specified delay
    ///
    /// - Parameters:
    ///   - repeatCount: used to control the repetition of the shimmer animation
    ///   - startDelay: used to add delay between each iteration
    ///
    ///  refer ``PopButton/endShimmerAnimation()`` to stop the running shimmer animation
    ///
    func startShimmerAnimation(repeatCount: Float = .infinity, startDelay: CGFloat = 0) {
        shimmerRepeatCount = repeatCount
        shimmerStartDelay = startDelay
        isShimmerActive = true
        setShimmerAnimation(on: buttonContentView.layer, repeatCount: repeatCount)
    }

    /// Use this method to end the running shimmer animation
    ///
    /// refer ``PopButton/startShimmerAnimation(repeatCount:startDelay:)`` to start new shimmer animation
    ///
    func endShimmerAnimation() {
        isShimmerActive = false
        stopShimmerAnimation(on: buttonContentView.layer)
    }

    private func setShimmerAnimation(on layer: CALayer, repeatCount: Float) {
        if case .disabled = buttonState {
            stopShimmerAnimation(on: layer)
            return
        }

        shimmerDelayTimer?.invalidate()
        shimmerDelayTimer = Timer.scheduledTimer(withTimeInterval: shimmerStartDelay, repeats: false, block: { [weak self] (_) in
            guard let self = self else { return }
            layer.startShimmerAnimation(type: self.model.shimmerStyle, repeatCount: repeatCount, addOnRoot: true)
        })
    }

    private func stopShimmerAnimation(on layer: CALayer) {
        shimmerDelayTimer?.invalidate()
        shimmerDelayTimer = nil
        layer.removeShimmerAnimation()
    }
}

private extension PopButton {

    /// Apply state change UI.
    /// This should only be invoked from internal action, from ``PopButton/isHighlighted`` variable.
    func applyUIChangeOnAction(isHighlighted: Bool, animate: Bool = true) {

        switch buttonState {
        case .loading, .success:
            return
        default:
            let latestState: PopButton.State = isHighlighted ? .pressed : .normal
            changeUIWithState(state: latestState, animate: animate)
        }

    }

    func changeUIWithState(state: PopButton.State, animate: Bool) {
        // Don't do the state change, if a transition is already happening.
        guard !isInTransition else {
            return
        }

        updateStateAndApplyHaptic(newState: state, enableHaptic: animate)
        isInTransition = true

        let isTransitioningToNormalState = state != .pressed
        updateUIState(pressed: state == .pressed)

        if animate {
            UIView.animate(withDuration: pressAnimationDuration, delay: 0, options: .allowUserInteraction) { [weak self] in
                self?.layoutIfNeeded()
            } completion: { [weak self] (completed) in
                // Let's revert back to present state is the state of the button is different after the animation is completed.
                // This has been added in order to have pressed state animation even on a quick tap also.
                // A quick tap will make the transition from highlighted to normal state in a fraction time.
                guard let self = self else { return }

                self.isInTransition = false
                if completed {
                    if self.buttonState.isHighLighted  !=  self.isHighlighted {
                        self.applyUIChangeOnAction(isHighlighted: self.isHighlighted)
                    }
                }
                if completed && isTransitioningToNormalState {
                    self.sendTouchEvent?()
                    self.sendTouchEvent = nil
                }
            }
        } else {
            isInTransition = false
        }
    }

    func updateUIState(pressed: Bool) {
        updateNormalStateNPViewFrame(isNormalState: !pressed)
        updateSelectedStateNPViewFrame(isSelectedState: pressed)
        updateContentViewFrame(isSelectedState: pressed)
    }

    // Create haptic effects.
    func updateStateAndApplyHaptic(newState: PopButton.State, enableHaptic: Bool) {

        guard buttonState != newState else {
            return
        }

        buttonState = newState

        guard enableHaptic else {
            return
        }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: Constraint Update Methods
private extension PopButton {

    ///
    /// Selected State `PopView` transition
    /// The selected state of the button is always in the same position, it will not be moving, while the center (button face) and `PopView` for normal state will be moving.
    ///
    func updateSelectedStateNPViewFrame(isSelectedState: Bool) {
        selectedPopViewConstraints?.top.constant = 0
        selectedPopViewConstraints?.leading.constant = 0
        selectedPopViewConstraints?.trailing.constant = 0
        selectedPopViewConstraints?.bottom.constant = 0
    }

    ///
    /// Normal state NeoPop component transition
    /// normal-state of the ``PopView`` which has to animate with the button state
    ///
    func updateNormalStateNPViewFrame(isNormalState: Bool) {
        let offset: UIEdgeInsets = isNormalState ? .zero : drawingManager.getNormalStateViewOffsets(popModel: model)
        normalPopViewConstraints?.top.constant = offset.top
        normalPopViewConstraints?.leading.constant = offset.left
        normalPopViewConstraints?.trailing.constant = -offset.right
        normalPopViewConstraints?.bottom.constant = -offset.bottom
    }

    ///
    /// Content view is the face of the button containing the contents
    ///
    func setupContentView() {

        buttonContentView.backgroundColor = .clear
        let customInsets = self.customInsets()
        buttonContentHolderViewConstraints?.top.constant = customInsets.top
        buttonContentHolderViewConstraints?.bottom.constant = -customInsets.bottom
        buttonContentHolderViewConstraints?.leading.constant = customInsets.left
        buttonContentHolderViewConstraints?.trailing.constant = -customInsets.right

        drawContentViewLayer() // Draw face of the button with button color. The normal/highlighted models will have center part hidden.
        drawStaticBorders() // Static borders at the base which will be immobile.
    }

    ///
    /// Content container view transition
    /// Content view is the button face. (button content)
    /// This will also be animating with button state change.
    ///
    func updateContentViewFrame(isSelectedState: Bool) {
        let offset = drawingManager.offsetForContentViewTransition(isPressedState: isSelectedState, buttonModel: model)

        buttonContentViewConstraints?.top.constant = offset.top
        buttonContentViewConstraints?.leading.constant = offset.left
        buttonContentViewConstraints?.trailing.constant = -offset.right
        buttonContentViewConstraints?.bottom.constant = -offset.bottom
    }
}

// MARK: Draw Methods
private extension PopButton {

    ///
    /// Draw face of the button with button color.
    /// because, the normal/highlighted models will have center part hidden.
    ///
    func drawContentViewLayer(forDisabledState: Bool = false) {
        buttonContentView.drawContents(isDisabled: forDisabledState)
    }

    // MARK: Static Borders

    ///
    /// Draw static borders ie, it will not be moving with press effects.
    ///
    func drawStaticBorders() {
        // Static borders are added in this layer.
        staticBorder.hideAllBorders()
        staticBorder.isHidden = false

        staticBorder.frame = bounds
        let borderWidth = model.borderWidth

        // Get static border points.
        let params = drawingManager.getPointsForStaticBorders(for: staticBorderColors, viewFrame: bounds, borderWidth: borderWidth, edgePadding: edgePadding)

        guard !params.isEmpty else {
            return
        }

        staticBorder.configureBorders(with: params)
        layer.addSublayer(staticBorder)
    }

    func hideStaticBorder() {
        staticBorder.hideAllBorders()
        staticBorder.isHidden = true
    }

    // MARK: Corner Edges

    /// //MERGE DONE
    /// For `PopButton` on specific positions, will to have a partially visible button face which i call button tail.
    /// we are adding the same here.
    ///
    func setupEdgeCornerPop(model: PopButton.Model) {
        let direction = model.direction
        let position = model.position
        let bgColor = model.backgroundColor
        cornerEdgeViewHeightConstraint?.constant = model.edgeLength
        let borderWidth = model.borderWidth
        let borderColor = model.buttonFaceBorderColor

        // Add constraints
        let layoutConstraints = drawingManager.constraintsForCornerTailView(on: buttonContentView, cornerView: cornerEdgeView)
        guard !layoutConstraints.isEmpty else {
            return
        }

        NSLayoutConstraint.activate(layoutConstraints)

        // Draw edge shape (button tail)
        drawCornerEdgeShapes(direction: direction, position: position, length: edgePadding, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
    }

    func drawCornerEdgeShapes(direction: EdgeDirection, position: PopButton.Position, length: CGFloat, color: UIColor, borderColor: EdgeColors?, borderWidth: CGFloat) {

        /// Corner shape defines the structure of the tail and the position of the border in the tail,
        /// which needs to be a continuation of the edge.
        func applyCornerViewMask(shape: CornerShape, length: CGFloat, color: UIColor) {

            let width = length
            var drawPoints: [CGPoint]?
            var linePoints: [CGPoint] = []

            var edgeBorderColor: UIColor = .clear

            // 'usedHorizontally' - to draw border on the horizontal edge or the vertical edge in the tail.

            switch shape {
            case .leftToBottomRightCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 0, y: width),
                    CGPoint(x: width, y: width),
                    CGPoint(x: 0, y: 0)
                ]
                linePoints = [
                    CGPoint(x: 0, y: width),
                    usedHorizontally.transformed(true: CGPoint(x: width, y: width), false: CGPoint(x: 0, y: 0))
                ]

                edgeBorderColor = usedHorizontally.transformed(true: borderColor?.bottom ?? .clear, false: borderColor?.left ?? .clear)
            case .leftToTopRightCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 0, y: width),
                    CGPoint(x: width, y: 0),
                    CGPoint(x: 0, y: 0)
                ]
                linePoints = [
                    CGPoint(x: 0, y: 0),
                    usedHorizontally.transformed(true: CGPoint(x: width, y: 0), false: CGPoint(x: 0, y: width))
                ]

                edgeBorderColor = usedHorizontally.transformed(true: borderColor?.top ?? .clear, false: borderColor?.left ?? .clear)

            case .rightToBottomLeftCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: width),
                    CGPoint(x: width, y: width),
                    CGPoint(x: width, y: 0),
                    CGPoint(x: 0, y: width)
                ]
                linePoints = [
                    CGPoint(x: width, y: width),
                    usedHorizontally.transformed(true: CGPoint(x: 0, y: width), false: CGPoint(x: width, y: 0))
                ]

                edgeBorderColor = usedHorizontally.transformed(true: borderColor?.bottom ?? .clear, false: borderColor?.right ?? .clear)

            case .rightToTopLeftCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: width, y: width),
                    CGPoint(x: width, y: 0),
                    CGPoint(x: 0, y: 0)
                ]
                linePoints = [
                    CGPoint(x: width, y: 0),
                    usedHorizontally.transformed(true: CGPoint(x: 0, y: 0), false: CGPoint(x: width, y: width))
                ]

                edgeBorderColor = usedHorizontally.transformed(true: borderColor?.top ?? .clear, false: borderColor?.right ?? .clear)

            case .none:
                cornerEdgeView.isHidden = true
                return
            }

            guard let points = drawPoints,
                  let point1 = points[safe: 0],
                  let point2 = points[safe: 1],
                  let point3 = points[safe: 2],
                  let point4 = points[safe: 3] else {
                cornerEdgeView.isHidden = true
                return
            }
            cornerEdgeView.isHidden = false

            // Draw the border here.
            if let point1 = linePoints[safe: 0], let point2 = linePoints[safe: 1] {
                cornerEdgeLineShape.frame = cornerEdgeView.bounds

                let linePath = UIBezierPath()
                linePath.move(to: point1)
                linePath.addLine(to: point2)
                linePath.close()
                cornerEdgeLineShape.strokeColor = edgeBorderColor.cgColor
                cornerEdgeLineShape.lineWidth = borderWidth

                cornerEdgeLineShape.path = linePath.cgPath
                if cornerEdgeLineShape.superlayer != cornerEdgeView.layer {
                    cornerEdgeLineShape.removeFromSuperlayer()
                    cornerEdgeView.layer.addSublayer(cornerEdgeLineShape)
                }
            }

            let path = CGMutablePath()

            path.move(to: point1)
            path.addLines(between: [point2, point3])
            path.addArc(tangent1End: point3, tangent2End: point4, radius: 0.0)
            path.addArc(tangent1End: point4, tangent2End: point1, radius: 4.0)
            path.addArc(tangent1End: point1, tangent2End: point2, radius: 2.0)

            cornerViewMask.position = .zero
            cornerViewMask.path = path

            cornerEdgeView.backgroundColor = color
            cornerEdgeView.layer.mask = cornerViewMask
        }

        let shape: CornerShape = drawingManager.getCornerTailDirection(position)

        applyCornerViewMask(shape: shape, length: length, color: color)
    }
}

// MARK: Setup Methods
private extension PopButton {
    func setup() {
        addSubview(selectedPopView)
        selectedPopViewConstraints = selectedPopView.fillSuperview()

        addSubview(normalPopView)
        normalPopViewConstraints = normalPopView.fillSuperview()

        // constraints for cornerEdgeView will be set at runtime
        addSubview(cornerEdgeView)
        cornerEdgeView.translatesAutoresizingMaskIntoConstraints = false
        cornerEdgeViewHeightConstraint = cornerEdgeView.heightAnchor.constraint(equalToConstant: 10)
        cornerEdgeViewHeightConstraint?.isActive = true
        cornerEdgeView.widthAnchor.constraint(equalTo: cornerEdgeView.heightAnchor).isActive = true

        addSubview(buttonContentHolderView)
        buttonContentHolderView.clipsToBounds = true
        buttonContentHolderViewConstraints = addConstraintsForContentView(buttonContentHolderView, on: self)

        buttonContentHolderView.addSubview(buttonContentView)
        buttonContentViewConstraints = addConstraintsForContentView(buttonContentView, on: buttonContentHolderView)

        setCustomContainerView(PopButtonContainerView())
        preWarmUI()
    }

    func preWarmUI() {
        self.titleLabel?.text = nil
        self.titleLabel?.isHidden = true

        self.backgroundColor = .clear
        selectedPopView.backgroundColor = .clear
        normalPopView.backgroundColor = .clear
        buttonContentView.backgroundColor = .clear

        selectedPopView.isUserInteractionEnabled = false
        normalPopView.isUserInteractionEnabled = false
        buttonContentView.isUserInteractionEnabled = false
        buttonContentHolderView.isUserInteractionEnabled = false

        clipsToBounds = true
        layer.masksToBounds = true
        applyUIChangeOnAction(isHighlighted: isHighlighted, animate: false)

        if let titleLabel = titleLabel {
            titleLabel.textColor = .clear
            self.sendSubviewToBack(titleLabel)
        }

        buttonContentView.drawingManager = drawingManager
        buttonContentView.config = model

        buttonContentsViewBoundsObserver = buttonContentView.observe(\PopContentView.bounds, options: [.new, .old]) { [weak self] (view, change) in
            guard change.newValue != change.oldValue,
                  let self = self,
                  self.isShimmerActive else {
                return
            }

            self.setShimmerAnimation(on: view.layer, repeatCount: self.shimmerRepeatCount)
        }
    }

    func addConstraintsForContentView(_ view: UIView, on superView: UIView) -> EdgeConstraints {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = view.topAnchor.constraint(equalTo: superView.topAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        let leadingConstraint = view.leadingAnchor.constraint(equalTo: superView.leadingAnchor)
        let trailingConstraint = view.trailingAnchor.constraint(equalTo: superView.trailingAnchor)

        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])

        return (leadingConstraint, trailingConstraint, topConstraint, bottomConstraint)
    }
}
