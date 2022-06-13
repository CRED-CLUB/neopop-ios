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

    private var drawingManager: PopButtonDrawable.Type = BottomRightButtonDrawManager.self {
        didSet {
            buttonContentView.drawingManager = drawingManager
        }
    }

    private var model: PopButton.Model = PopButton.Model.createButtonModel(position: .bottomRight, buttonColor: .clear, superViewColor: nil, parentContainerBGColor: nil, edgeWidth: 0) {
        didSet {
            buttonContentView.config = model
        }
    }

    private var staticBorderColors: (horizontal: UIColor?, vertical: UIColor?)?
    private var staticBorder = PopContentLayer()

    private let pressAnimationDuration: Double = PopConfiguration.PopButton.pressDuration

    private var isInTransition: Bool = false
    private weak var customContainer: PopButtonCustomContainerDrawable?

    private var sendTouchEvent: (() -> Void)?

    private var currentFrame: CGRect?

    open var buttonState: PopButton.State = .unknown {
        willSet {
            customContainer?.updateOnStateChange(state: newValue)
        }
    }

    /// Use this property to control the button click event.
    /// When it is `true`, `touchUpInside` event will be triggered after click animation ends, else it will be triggered immediately.
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
        drawStaticBorders() // Static borders at the base which will be im-mobile.
    }
}

public extension PopButton {
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

    func configureButtonContent(withModel model: CustomButtonContainerView.Model) {
        guard let container = customContainer as? CustomButtonContainerView else { return }
        container.configureView(withModel: model)
    }

    func setCustomContainerView(_ view: PopButtonCustomContainerDrawable) {
        customContainer = view
        buttonContentView.addSubview(view)
        view.fillSuperview()
    }

    func removeCustomContainer() {
        customContainer?.removeFromSuperview()
    }

    // TODO: remove completion if not needed.
    func changeButtonState(newState: PopButton.State, completion: ((_ success: Bool) -> Void)?) {

        guard newState != buttonState else {
            completion?(false)
            return
        }

        // Change from disabled to any state needs the default setups.
        if case .disabled(let disabledStateWithOpacity) = buttonState,
           case disabledStateWithOpacity = false {
            normalPopView.configurePopView(withModel: getNormalModel())
            drawContentViewLayer()
            drawStaticBorders()
        }

        // Update the opcacity to 1.
        alpha = 1

        switch newState {
        case .pressed, .unknown:
            completion?(false)
            return

        case .normal:
            isEnabled = true
            buttonState = newState
            completion?(true)

        case .loading:
            isEnabled = false
            buttonState = newState
            completion?(true)

        case .success:
            isEnabled = false
            buttonState = newState
            completion?(true)

        // TODO: incase of success we call completion after lottie plays. what should we do here
        //            playLottie(lottieName: configModel.successLottieData.name, frame: configModel.successLottieData.range, loopMode: .playOnce) { () in
        //                completion?(true)
        //            }

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
            completion?(true)
        }
    }
}

// MARK: Shimmer Methods
public extension PopButton {
    func startShimmerAnimation(repeatCount: Float = .infinity, startDelay: CGFloat = 0) {
        shimmerRepeatCount = repeatCount
        shimmerStartDelay = startDelay
        isShimmerActive = true
        setShimmerAnimation(on: buttonContentView.layer, repeatCount: repeatCount)
    }

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
        shimmerDelayTimer = Timer.scheduledTimer(withTimeInterval: shimmerStartDelay, repeats: false, block: { (_) in
            layer.startShimmerAnimation(type: self.model.shimmerStyle, repeatCount: repeatCount, addOnRoot: true)
        })
    }

    private func stopShimmerAnimation(on layer: CALayer) {
        shimmerDelayTimer?.invalidate()
        shimmerDelayTimer = nil
        layer.removeShimmerAnimation()
    }
}

public extension PopButton {

    /// Apply state change UI.
    /// This should only be invoked from internal action, from isHighlighted variable.
    private func applyUIChangeOnAction(isHighlighted: Bool, animate: Bool = true) {

        switch buttonState {
        case .loading, .success:
            return
        default:
            let latestState: PopButton.State = isHighlighted ? .pressed : .normal
            changeUIWithState(state: latestState, animate: animate)
        }

    }

    private func changeUIWithState(state: PopButton.State, animate: Bool) {
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
                // This has been added inorder to have pressed state animation even on a quick tap also.
                // A quick tap will make the transition from highlisted to normal state in a fraction time.
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

    private func updateUIState(pressed: Bool) {
        updateNormalStateNPViewFrame(isNormalState: !pressed)
        updateSelectedStateNPViewFrame(isSelectedState: pressed)
        updateContentViewFrame(isSelectedState: pressed)
    }

    // Create haptic effects.
    private func updateStateAndApplyHaptic(newState: PopButton.State, enableHaptic: Bool) {

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
    private func updateSelectedStateNPViewFrame(isSelectedState: Bool) {
        selectedPopViewConstraints?.top.constant = 0
        selectedPopViewConstraints?.leading.constant = 0
        selectedPopViewConstraints?.trailing.constant = 0
        selectedPopViewConstraints?.bottom.constant = 0
    }

    ///
    /// Normal state NeoPop component transition
    /// normal-state Neopop view  has to animate with the button state
    ///
    private func updateNormalStateNPViewFrame(isNormalState: Bool) {
        let offset: UIEdgeInsets = isNormalState ? .zero : drawingManager.getNormalStateViewOffsets(neopopModel: model)
        normalPopViewConstraints?.top.constant = offset.top
        normalPopViewConstraints?.leading.constant = offset.left
        normalPopViewConstraints?.trailing.constant = -offset.right
        normalPopViewConstraints?.bottom.constant = -offset.bottom
    }

    ///
    /// Content view is the face of the button contaiing the contents
    ///
    private func setupContentView() {

        buttonContentView.backgroundColor = .clear
        let customInsets = self.customInsets()
        buttonContentHolderViewConstraints?.top.constant = customInsets.top
        buttonContentHolderViewConstraints?.bottom.constant = -customInsets.bottom
        buttonContentHolderViewConstraints?.leading.constant = customInsets.left
        buttonContentHolderViewConstraints?.trailing.constant = -customInsets.right

        drawContentViewLayer() // Draw face of the button with button color. The normal/highlighted models will have center part hidden.
        drawStaticBorders() // Static borders at the base which will be im-mobile.
    }

    ///
    /// Content container view transition
    /// Content view is the button face. (button content)
    /// This will also be animating with button state change.
    ///
    private func updateContentViewFrame(isSelectedState: Bool) {
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

        let borderModels = params.map { PopContentLayer.BorderModel(start: $0.start, end: $0.destin, color: $0.color, borderWidth: $0.width) }
        staticBorder.configureBorders(with: borderModels)
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
    private func setupEdgeCornerPop(model: PopButton.Model) {
        let direction = model.direction
        let position = model.position
        let bgColor = model.backgroundColor
        cornerEdgeViewHeightConstraint?.constant = model.edgeLength
        let borderWidth = model.borderWidth
        let borderColor = model.buttonFaceBorderColor

        // Add constraints
        let layoutConstaints = drawingManager.constaintsForCornerTailView(on: buttonContentView, cornerView: cornerEdgeView)
        guard !layoutConstaints.isEmpty else {
            return
        }

        // TODO: constraints added always. need to check for existing constraints
        NSLayoutConstraint.activate(layoutConstaints)

        // Draw edge shape (button tail)
        drawCornerEdgeShapes(direction: direction, position: position, length: edgePadding, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
    }

    private func drawCornerEdgeShapes (direction: EdgeDirection, position: PopButton.Position, length: CGFloat, color: UIColor, borderColor: EdgeColors?, borderWidth: CGFloat) {

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
                linePoints = [CGPoint(x: 0, y: width),
                              (usedHorizontally ? CGPoint(x: width, y: width) : CGPoint(x: 0, y: 0))]

                edgeBorderColor = usedHorizontally ? borderColor?.bottom ?? .clear : borderColor?.left ?? .clear
            case .leftToTopRightCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 0, y: width),
                    CGPoint(x: width, y: 0),
                    CGPoint(x: 0, y: 0)
                ]
                linePoints = [CGPoint(x: 0, y: 0),
                              usedHorizontally ? CGPoint(x: width, y: 0) : CGPoint(x: 0, y: width)]
                edgeBorderColor = usedHorizontally ? borderColor?.top ?? .clear : borderColor?.left ?? .clear

            case .rightToBottomLeftCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: width),
                    CGPoint(x: width, y: width),
                    CGPoint(x: width, y: 0),
                    CGPoint(x: 0, y: width)
                ]
                linePoints = [CGPoint(x: width, y: width),
                              usedHorizontally ? CGPoint(x: 0, y: width) : CGPoint(x: width, y: 0)]
                edgeBorderColor = usedHorizontally ? borderColor?.bottom ?? .clear : borderColor?.right ?? .clear

            case .rightToTopLeftCorner(let usedHorizontally):
                drawPoints = [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: width, y: width),
                    CGPoint(x: width, y: 0),
                    CGPoint(x: 0, y: 0)
                ]
                linePoints = [CGPoint(x: width, y: 0),
                              usedHorizontally ? CGPoint(x: 0, y: 0) : CGPoint(x: width, y: width)]
                edgeBorderColor = usedHorizontally ? borderColor?.top ?? .clear : borderColor?.right ?? .clear

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

// MARK: PopView Model Generators
private extension PopButton {

    ///
    /// Custom insets has a great role in controlling the visibility of the button's center part.
    /// while drawing few positions the button face will be partically visible in order to show the 3D effect that it has went inside.
    /// So these insets will be used for that.
    ///
    private func customInsets() -> UIEdgeInsets {
        return drawingManager.buttonCustomInsets(buttonModel: model)
    }

    ///
    /// This method returns the model for highlited state of the button
    /// w.r.t to the direction of the button and the position of the button this model values differs.
    /// we decide the `edge visibility`, `border visibility`, `edge color`, `border color`, whether to clip the edge etc.
    ///
    private func getHighlightedModel() -> PopView.Model {

        // whether clip any edge on he head OR tail.
        var clipEdgeToOffsetWidth: EdgeClipping = .none
        var clipEdgeToOffsetHeight: EdgeClipping = .none

        // visibility of the edge.
        var customEdgeVisibility: EdgeVisibilityModel?
        var customBorderVisibility: EdgeVisibilityModel?

        // color of the superview of the NeoView holding the button.
        let parentContanerBGColor = model.parentContainerBGColor ?? .clear

        // color of the NeoView holding the button.
        let neuSuperViewBGColor = model.superViewColor ?? .clear

        // Vertical and horizontal edge colors.
        var verticalEdgeColor: UIColor = PopHelper.verticalEdgeColor(for: neuSuperViewBGColor)
        var horizontalEdgeColor: UIColor = PopHelper.horizontalEdgeColor(for: neuSuperViewBGColor)

        // direction of the pressed state model
        let direction = normalStateEdgeDirection.selectedDirection

        // In the use case of, whether an adjacent button is available, some of the sides which arent available needs to be shown in some positions.
        // which is controlled by these params.
        let reverseBottomEdgeVisibility: Bool = model.adjacentButtonAvailibity?.bottom ?? false
        let reverseTopEdgeVisibility: Bool = model.adjacentButtonAvailibity?.top ?? false
        let reverseRightEdgeVisibility: Bool = model.adjacentButtonAvailibity?.right ?? false
        let reverseLeftEdgeVisibility: Bool = model.adjacentButtonAvailibity?.left ?? false

        // Border colors
        var verticalEdgeBorderColor: EdgeColors?
        var horizontalEdgeBorderColor: EdgeColors?

        let position = model.position

        // Show/Hide edges
        var hideBottomEdge = false
        var hideTopEdge = false
        var hideRightEdge = false
        var hideLeftEdge = false
        /*
         for hiding the edges of the highlighted model, we need to see the positions of the button (not on edges where super view is visible) after which we can consider whethere to hide the edge or not.
         */

        switch direction { // Selection direction
        case .topLeft:

            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            // This is common config for topleft
            hideBottomEdge = false
            hideTopEdge = reverseTopEdgeVisibility ? true : false
            hideRightEdge = false
            hideLeftEdge = reverseLeftEdgeVisibility ? true : false

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

            switch position {

            case .bottomRight:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .bottomEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .bottomLeft:
                clipEdgeToOffsetWidth = .clipDistantCorners
                verticalEdgeColor = parentContanerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .leftEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                verticalEdgeColor = parentContanerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .topLeft:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                verticalEdgeColor = parentContanerBGColor
                horizontalEdgeColor = parentContanerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .topEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                horizontalEdgeColor = parentContanerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .topRight:
                clipEdgeToOffsetHeight = .clipDistantCorners
                horizontalEdgeColor = parentContanerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .rightEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .center:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            }

        case .topRight:

            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            // This is common config for topRight
            hideBottomEdge = false
            hideTopEdge = reverseTopEdgeVisibility ? true : false
            hideRightEdge = reverseRightEdgeVisibility ? true : false
            hideLeftEdge = false

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

            switch position {

            case .bottomLeft:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .bottomRight:
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .bottomEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .leftEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topLeft:
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topEdge:
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topRight:
                horizontalEdgeColor = parentContanerBGColor
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .rightEdge:
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .center:
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            }

        case .bottomLeft:

            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            // This is common config for bottomLeft
            hideBottomEdge = reverseBottomEdgeVisibility ? true : false
            hideTopEdge = false
            hideRightEdge = false
            hideLeftEdge = reverseLeftEdgeVisibility ? true : false

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            switch position {
            case .topRight:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .topEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .topLeft:
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .leftEdge:
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .bottomLeft:
                verticalEdgeColor = parentContanerBGColor
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .bottomEdge:
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .bottomRight:
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .rightEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .center:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)
            }

        case .bottomRight:

            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            // This is common config for topleft
            hideBottomEdge = reverseBottomEdgeVisibility ? true : false
            hideTopEdge = false
            hideRightEdge = reverseRightEdgeVisibility ? true : false
            hideLeftEdge = false

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            switch position {
            case .topLeft:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topRight:
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .rightEdge:
                verticalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .bottomRight:
                verticalEdgeColor = parentContanerBGColor
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .bottomEdge:
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .bottomLeft:
                horizontalEdgeColor = parentContanerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .leftEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)
            case .center:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)
            }

        case .top:
            // This is common config for Top
            hideBottomEdge = false
            hideTopEdge =  true
            hideRightEdge = false
            hideLeftEdge = false

            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: false, hideCenterPath: true)

        case .bottom:
            // This is common config for Bottom
            hideBottomEdge = true
            hideTopEdge =  false
            hideRightEdge = false
            hideLeftEdge = false

            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        case .right:
            hideBottomEdge = false
            hideTopEdge =  false
            hideRightEdge = true
            hideLeftEdge = false

            horizontalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        case .left:
            hideBottomEdge = false
            hideTopEdge =  false
            hideRightEdge = false
            hideLeftEdge = true

            horizontalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        }

        customEdgeVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        return PopView.Model(neoPopEdgeDirection: direction, customEdgeVisibility: customEdgeVisibility, customBorderVisibility: customBorderVisibility, edgeOffSet: edgePadding, backgroundColor: .clear, verticalEdgeColor: verticalEdgeColor, horizontalEdgeColor: horizontalEdgeColor, verticalBorderColors: verticalEdgeBorderColor, horizontalBorderColors: horizontalEdgeBorderColor, clipsToOffSetWidth: clipEdgeToOffsetWidth, clipsToOffSetHeight: clipEdgeToOffsetHeight, borderWidth: model.borderWidth)
    }

    ///
    /// This method returns the model for normal state of the button
    /// w.r.t to the direction of the button and the position of the button this model values differs.
    ///
    private func getNormalModel(forDisabledState disabled: Bool = false) -> PopView.Model {

        var clipEdgeToOffsetWidth: EdgeClipping = .none
        var clipEdgeToOffsetHeight: EdgeClipping = .none

        var customEdgeVisibility: EdgeVisibilityModel?
        let customBorderVisibility: EdgeVisibilityModel? = nil

        let buttonBGColor = disabled ? UIColor.fromHex("8A8A8A") : model.backgroundColor
        let showStaticEdge: Bool = disabled ? false : model.showStaticBaseEdges

        var verticalEdgeColor: UIColor = PopHelper.verticalEdgeColor(for: buttonBGColor)
        var horizontalEdgeColor: UIColor = PopHelper.horizontalEdgeColor(for: buttonBGColor)

        let reverseBottomEdgeVisibility: Bool = model.adjacentButtonAvailibity?.bottom ?? false
        let reverseTopEdgeVisibility: Bool = model.adjacentButtonAvailibity?.top ?? false
        let reverseRightEdgeVisibility: Bool = model.adjacentButtonAvailibity?.right ?? false
        let reverseLeftEdgeVisibility: Bool = model.adjacentButtonAvailibity?.left ?? false

        var verticalEdgeBorderColor: EdgeColors?
        var horizontalEdgeBorderColor: EdgeColors?

        let position = model.position
        var hideBottomEdge = false
        var hideTopEdge = false
        var hideRightEdge = false
        var hideLeftEdge = false

        switch normalStateEdgeDirection {
        case .bottomRight:
            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.bottom, verticalEdgeBorderColor?.right)
                verticalEdgeBorderColor?.right = nil
                horizontalEdgeBorderColor?.bottom = nil
            }

            switch position {
            case .bottomRight:
                hideBottomEdge = reverseBottomEdgeVisibility ? true : false
                hideRightEdge = reverseRightEdgeVisibility ? true : false

            case .bottomEdge, .bottomLeft:
                hideBottomEdge = reverseBottomEdgeVisibility ? true : false
                hideRightEdge = reverseRightEdgeVisibility ? false : true

            case .leftEdge, .topLeft, .topEdge:
                hideBottomEdge = reverseBottomEdgeVisibility ? false : true
                hideRightEdge = reverseRightEdgeVisibility ? false : true
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .topRight, .rightEdge:
                hideBottomEdge = reverseBottomEdgeVisibility ? false : true
                hideRightEdge = reverseRightEdgeVisibility ? true : false

            case .center:
                hideBottomEdge = reverseBottomEdgeVisibility ? false : true
                hideRightEdge = reverseRightEdgeVisibility ? false : true

            }

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

        case .bottomLeft:
            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.bottom, verticalEdgeBorderColor?.left)
                verticalEdgeBorderColor?.left = nil
                horizontalEdgeBorderColor?.bottom = nil
            }

            switch position {
            case .bottomLeft:
                hideBottomEdge = reverseBottomEdgeVisibility ? true : false
                hideLeftEdge = reverseLeftEdgeVisibility ? true : false

            case .bottomEdge, .bottomRight:
                hideBottomEdge = reverseBottomEdgeVisibility ? true : false
                hideLeftEdge = reverseLeftEdgeVisibility ? false : true

            case .rightEdge, .topRight, .topEdge:
                hideBottomEdge = reverseBottomEdgeVisibility ? false : true
                hideLeftEdge = reverseLeftEdgeVisibility ? false : true
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .topLeft, .leftEdge:
                hideBottomEdge = reverseBottomEdgeVisibility ? false : true
                hideLeftEdge = reverseLeftEdgeVisibility ? true : false

            case .center:
                hideBottomEdge = reverseBottomEdgeVisibility ? false : true
                hideLeftEdge = reverseLeftEdgeVisibility ? false : true

            }

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

        case .topRight:
            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.top, verticalEdgeBorderColor?.right)
                verticalEdgeBorderColor?.right = nil
                horizontalEdgeBorderColor?.top = nil
            }

            switch position {
            case .topRight:
                hideTopEdge = reverseTopEdgeVisibility ? true : false
                hideRightEdge = reverseRightEdgeVisibility ? true : false

            case .topEdge, .topLeft:
                hideTopEdge = reverseTopEdgeVisibility ? true : false
                hideRightEdge = reverseRightEdgeVisibility ? false : true

            case .leftEdge, .bottomLeft, .bottomEdge:
                hideTopEdge = reverseTopEdgeVisibility ? false : true
                hideRightEdge = reverseRightEdgeVisibility ? false : true
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .bottomRight, .rightEdge:
                hideTopEdge = reverseTopEdgeVisibility ? false : true
                hideRightEdge = reverseRightEdgeVisibility ? true : false

            case .center:
                hideTopEdge = reverseTopEdgeVisibility ? false : true
                hideRightEdge = reverseRightEdgeVisibility ? false : true

            }

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

        case .topLeft:
            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.top, verticalEdgeBorderColor?.left)
                verticalEdgeBorderColor?.left = nil
                horizontalEdgeBorderColor?.top = nil
            }

            switch position {
            case .topLeft:
                hideTopEdge = reverseTopEdgeVisibility ? true : false
                hideLeftEdge = reverseLeftEdgeVisibility ? true : false

            case .topEdge, .topRight:
                hideTopEdge = reverseTopEdgeVisibility ? true : false
                hideLeftEdge = reverseLeftEdgeVisibility ? false : true

            case .rightEdge, .bottomRight, .bottomEdge:
                hideTopEdge = reverseTopEdgeVisibility ? false : true
                hideLeftEdge = reverseLeftEdgeVisibility ? false : true
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .bottomLeft, .leftEdge:
                hideTopEdge = reverseTopEdgeVisibility ? false : true
                hideLeftEdge = reverseLeftEdgeVisibility ? true : false

            case .center:
                hideTopEdge = reverseTopEdgeVisibility ? false : true
                hideLeftEdge = reverseLeftEdgeVisibility ? false : true

            }

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

        case .bottom:
            hideBottomEdge = reverseBottomEdgeVisibility ? true : false
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.bottom, nil)
                horizontalEdgeBorderColor?.bottom = nil
            }

        default:
            break
        }

        // No border for disabled state.
        verticalEdgeBorderColor = disabled ? nil : verticalEdgeBorderColor
        horizontalEdgeBorderColor = disabled ? nil : horizontalEdgeBorderColor

        customEdgeVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        return PopView.Model(neoPopEdgeDirection: normalStateEdgeDirection, customEdgeVisibility: customEdgeVisibility, customBorderVisibility: customBorderVisibility, edgeOffSet: edgePadding, backgroundColor: .clear, verticalEdgeColor: verticalEdgeColor, horizontalEdgeColor: horizontalEdgeColor, verticalBorderColors: verticalEdgeBorderColor, horizontalBorderColors: horizontalEdgeBorderColor, clipsToOffSetWidth: clipEdgeToOffsetWidth, clipsToOffSetHeight: clipEdgeToOffsetHeight, delegate: nil, modelIdentifier: "btn_normal_state_model", borderWidth: model.borderWidth)

    }
}

// MARK: Setup Methods
private extension PopButton {
    func setup() {
        addSubview(selectedPopView)
        selectedPopViewConstraints = selectedPopView.fillSuperview()

        addSubview(normalPopView)
        normalPopViewConstraints = normalPopView.fillSuperview()

        // comstraints for cornerEdgeView will be set at runtime
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

        setCustomContainerView(CustomButtonContainerView())
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

        titleLabel?.textColor = .clear
        self.sendSubviewToBack(titleLabel!)
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

// MARK: Convenient Button Properties
private extension PopButton {
    var normalStateEdgeDirection: EdgeDirection {
        model.direction
    }

    var neoButttonBackgroundColor: UIColor {
        model.backgroundColor
    }

    var neoButtonBorderColor: PopButton.BorderModel? {
        model.borderColors
    }

    var customEdgeColor: EdgeColors? {
        model.customEdgeColor
    }

    var buttonFaceBorderColor: EdgeColors? {
        model.buttonFaceBorderColor
    }

    var parentBGColor: UIColor {
        model.parentContainerBGColor ?? .clear
    }

    var edgePadding: CGFloat {
        model.edgeLength
    }
}
