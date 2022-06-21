//
//  PopFloatingButton.swift
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

/// It is a pop button with shadow exhibiting a floating effect.
///
/// - To configure the appearance of the button
///
/// ```swift
/// button.configureFloatingButton(
///    withModel: PopFloatingButton.Model(
///         backgroundColor: ColorHelper.popYellow500,
///         edgeWidth: 9,
///         shimmerModel: PopShimmerModel(
///             spacing: 10,
///             lineColor1: ColorHelper.popWhite500,
///             lineColor2: ColorHelper.popWhite500,
///             lineWidth1: 16,
///             lineWidth2: 35,
///             duration: 2,
///             delay: 5
///         )
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
///         rightImage: UIImage(named: "right_arrow"),
///         rightImageTintColor: UIColor.black
///     )
/// )
/// ```
///
/// - To start levitation motion
///
/// ```swift
/// button.startLevitatingMotion()
/// ```
///
/// - To start shimmer animation
///
/// ```swift
/// button.startShimmerAnimation()
/// ```
///
open class PopFloatingButton: UIButton {
    private let floatingView = PopView()
    private let shadowView = PopView()
    private weak var customContainer: PopFloatingButtonCustomContainerDrawable?

    private let buttonContentLayoutGuide = UILayoutGuide()

    private var floatingViewTopConstraint: NSLayoutConstraint?
    private var shadowViewBottomConstraint: NSLayoutConstraint?
    private var shadowViewWidthConstraint: NSLayoutConstraint?
    private var buttonContentCenterYConstraint: NSLayoutConstraint?

    private var isMovingUpOrDown: Bool = false
    private var levitationTimer: Timer?
    private var shimmerDelayTimer: Timer?

    private var model = Model()

    // MARK: Config properties
    private let touchDownAnimationDuration: TimeInterval = PopConfiguration.PopFloatingButton.touchDownDuration
    private let touchUpAnimationDuration: TimeInterval = PopConfiguration.PopFloatingButton.touchUpDuration
    private let levitatingAnimationDuration: Double = PopConfiguration.PopFloatingButton.levitatingAnimationDuration

    /// Offset of shadow that will be visible on touch down state.
    private let shadowOffSetOnTouchDown: CGFloat = 0.0
    var shadowsHiddenHeight: CGFloat {
        return model.edgeWidth
    }

    ///
    /// `floatViewMovementRatioOnTouchDown` & `shadowMovementRatioOnTouchDown` represents what % of the shadow height should be covered
    /// by float view and shadow while animating.
    /// `floatViewMovementRatioOnTouchDown + shadowMovementRatioOnTouchDown` should be 1.0
    /// default behavior is 50% & 50%
    ///
    private let floatViewMovementRatioOnTouchDown: CGFloat = 0.5
    private let shadowMovementRatioOnTouchDown: CGFloat = 0.5

    /// 50% movement is sufficient for levitating
    private let floatingViewMovementRatioOnLevitating: CGFloat = 0.4
    private let shadowMovementRatioOnLevitating: CGFloat = 0.2

    /// Actual offset of shadow view from float view
    private var shadowDefaultOffset: CGFloat {
        return (bounds.height / 4) + model.edgeWidth
    }

    /// visible offset of shadow view from float view, shadow has a hidden part as edge.
    private var visibleShadowHeight: CGFloat {
        return shadowDefaultOffset - shadowsHiddenHeight
    }

    private var currentFrame: CGRect?

    private var enableNextLevitation: Bool = false

    private var sendTouchEvent: (() -> Void)?

    private var disableOnNextClickWithAlpha: Bool?
    private var isInDisabledState: Bool = false
    private var hasTouchesEndedInside: Bool = false

    /// Use this property to control the button click event.
    /// When it is `true`, `touchUpInside` event will be triggered after click animation ends, else it will be triggered immediately.
    /// Default value is `true`
    public var delayTouchEvents: Bool = true

    open override var isHighlighted: Bool {
        willSet {
            guard newValue != isHighlighted else { return }
            updateButton(isHighlighted: newValue, applyHaptic: true)
        }
    }

    open override var bounds: CGRect {
        didSet {
            guard bounds != oldValue else { return }
            reconfigurePopViews()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public init() {
        super.init(frame: CGRect.zero)
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

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hasTouchesEndedInside = false
        super.touchesBegan(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hasTouchesEndedInside = event?.firstTouchToControlEvent() == .touchUpInside || isHighlighted
        super.touchesEnded(touches, with: event)
    }

    deinit {
        levitationTimer?.invalidate()
    }
}

// MARK: Configure Methods
public extension PopFloatingButton {

    /// Use this method to configure and update the appearance of the button.
    /// - Parameter model: the model which contains all the properties related to appearance of the ``PopFloatingButton``
    ///
    /// refer ``PopFloatingButton/Model`` for configurable properties.
    ///
    func configureFloatingButton(withModel model: Model) {
        self.model = model
        titleLabel?.isHidden = true
        titleLabel?.text = ""
        shadowViewBottomConstraint?.constant = -shadowDefaultOffset //
        shadowViewWidthConstraint?.constant = -(2 * model.edgeWidth) // set width of the shadow equal to bottom edge width
        buttonContentCenterYConstraint?.constant = -model.edgeWidth/2

        normalStateSetup()

        customContainer?.updateOnStateChange(state: .normal)
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

    /// Use this method to disable the button either immediately or
    /// - Parameters:
    ///   - withAlpha: should disable with alpha or not
    ///
    /// refer ``PopFloatingButton/enableButton()`` to enable the button
    ///
    func disableButtonImmediately(withAlpha: Bool = false) {

        guard !isInDisabledState else {
            return
        }

        changeToDisabled(withAlpha: withAlpha)
    }

    /// Use this method to disable the button when button is clicked.
    /// - Parameter withAlpha: should disable with alpha or not
    ///
    /// refer ``PopFloatingButton/enableButton()`` to enable the button
    ///
    func disableButtonOnNextClick(withAlpha: Bool = false) {
        guard !isInDisabledState else {
            return
        }

        disableOnNextClickWithAlpha = withAlpha
    }

    /// Use this method to enable the button if it is disabled.
    ///
    /// refer ``PopFloatingButton/disableButtonImmediately(withAlpha:)`` or ``PopFloatingButton/disableButtonOnNextClick(withAlpha:)`` for disabling the buttons
    ///
    func enableButton() {
        disableOnNextClickWithAlpha = nil

        guard isInDisabledState else {
            return
        }

        isInDisabledState = false
        self.floatingView.alpha = 1.0
        self.shadowView.alpha = 1.0
        self.normalStateSetup()
        isEnabled = true

        customContainer?.updateOnStateChange(state: .normal)

        UIView.animate(withDuration: touchUpAnimationDuration, delay: 0, options: .allowUserInteraction) {
            self.layoutIfNeeded()
        } completion: { _ in }
    }
}

// MARK: Custom Container Methods
public extension PopFloatingButton {
    /// Use this method to inject custom content view.
    /// it enables you to add label and imageViews of your choice
    ///
    /// - Parameter view: a view that conforms to ``PopButtonCustomContainerDrawable``
    ///
    /// refer ``PopFloatingButton/configureButtonContent(withModel:)`` to use existing content view
    ///
    /// refer ``PopFloatingButton/removeCustomContainer()`` to remove injected content view
    ///
    func setCustomContainerView(_ view: PopButtonCustomContainerDrawable) {
        customContainer = view
        floatingView.addSubview(view)
        view.fill(in: buttonContentLayoutGuide)
    }

    /// Use this method remove custom content view which was inject using ``PopFloatingButton/setCustomContainerView(_:)``
    func removeCustomContainer() {
        customContainer?.removeFromSuperview()
    }
}

// MARK: Levitation Methods
public extension PopFloatingButton {
    /// Use this method to start levitating motion (AKA floating) of the button
    ///
    /// refer ``PopFloatingButton/stopLevitatingMotion()`` to stop the motion
    ///
    func startLevitatingMotion() {
        invalidateTimer()

        let timeDuration = TimeInterval(2.5 * levitatingAnimationDuration)
        levitationTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)

        DispatchQueue.main.async {
            self.timerFired()
        }
    }

    /// Use this method to stop the levitating motion
    ///
    /// refer ``PopFloatingButton/startLevitatingMotion()`` to start the motion
    ///
    func stopLevitatingMotion() {
        layoutIfNeeded()
        invalidateTimer()
    }

    @objc private func timerFired() {
        guard enableNextLevitation else { // Do not proceed if disabled
            return
        }

        updateButton(isHighlighted: true, isLevitating: true)
    }

    private func invalidateTimer() {
        levitationTimer?.invalidate()
        levitationTimer = nil
    }
}

// MARK: Shimmer Methods
public extension PopFloatingButton {

    /// Use this method to start shimmer animation on the button.
    /// it highlights the button by moving from start to end continuously with specified delay
    ///
    /// - Parameters:
    ///   - repeatCount: used to control the repetition of the shimmer animation
    ///   - startDelay: used to add delay between each iteration
    ///
    ///  refer ``PopFloatingButton/endShimmerAnimation()`` to stop the running shimmer animation
    ///
    func startShimmerAnimation(repeatCount: Float = .infinity, startDelay: CGFloat = 0) {
        shimmerDelayTimer?.invalidate()
        shimmerDelayTimer = Timer.scheduledTimer(withTimeInterval: startDelay, repeats: false, block: { [weak self] (_) in
            guard let self = self else { return }
            self.floatingView.startShimmer(repeatCount: repeatCount, shimmerModel: self.model.shimmerModel)
        })
    }

    /// Use this method to update the shimmer model which is used to modify the appearance of the shimmer
    /// - Parameter shimmerModel: it contains all the properties used to control the appearance
    func setShimmerModel(_ shimmerModel: PopShimmerModel) {
        self.model.shimmerModel = shimmerModel
    }

    /// Use this method to end the running shimmer animation
    ///
    /// refer ``PopFloatingButton/startShimmerAnimation(repeatCount:startDelay:)`` to start new shimmer animation
    ///
    func endShimmerAnimation() {
        shimmerDelayTimer?.invalidate()
        shimmerDelayTimer = nil
        floatingView.stopShimmer()
    }
}

// MARK: Animation Methods
private extension PopFloatingButton {
    func updateConstraintsForTouchDown(isLevitating: Bool) {
        let floatMovement = isLevitating ? floatingViewMovementRatioOnLevitating : floatViewMovementRatioOnTouchDown
        let shadowMovement = isLevitating ? shadowMovementRatioOnLevitating : shadowMovementRatioOnTouchDown

        let floatViewMovementConstant = visibleShadowHeight * floatMovement
        // Negative offset for shadow
        let shadowMovementConstant = (((visibleShadowHeight * (1 - shadowMovement)) + shadowsHiddenHeight) + shadowOffSetOnTouchDown)

        floatingViewTopConstraint?.constant = floatViewMovementConstant
        shadowViewBottomConstraint?.constant = shadowMovementConstant
    }

    func updateConstraintsForTouchUp() {
        floatingViewTopConstraint?.constant = 0
        shadowViewBottomConstraint?.constant = shadowDefaultOffset
    }

    func updateButton(isHighlighted: Bool,
                      animate: Bool = true,
                      isLevitating: Bool = false,
                      applyHaptic: Bool = false) {
        // Case 1:
        // This is to enable the touch down effect on a single tap:
        // Usually on single tap the highlighted and normal states just occurs one after the other so, animation completes in very short time.

        // Case 2:
        // if levitation is disabled and request for state change is coming from levitation.
        guard !isMovingUpOrDown && !(!enableNextLevitation && isLevitating) && !isInDisabledState else {
            return
        }

        if hasTouchesEndedInside && !isHighlighted && !isLevitating,
           let disableOnNextClickWithAlpha = disableOnNextClickWithAlpha {
            triggerDisableState(disableOnNextClickWithAlpha)
            return
        }

        isMovingUpOrDown = isLevitating ? false : true
        var isTransitioningToNormalState = false

        if isHighlighted {
            if !isLevitating { // if it's not a levitation motion then disable levitation until normal state is invoked.
                enableNextLevitation = false
            }
            updateConstraintsForTouchDown(isLevitating: isLevitating)
        } else {
            // enable levitation on normal state.
            isTransitioningToNormalState = true
            enableNextLevitation = true
            updateConstraintsForTouchUp()
        }

        // Apply Haptic
        if applyHaptic {
            updateStateAndApplyHaptic(isHighlighted: isHighlighted)
        }

        guard animate else {
            self.isMovingUpOrDown = false
            return
        }

        // animation duration is decided w.r.t if it is levitating or touch down.
        let animationDuration = isLevitating ? levitatingAnimationDuration : isHighlighted ? touchDownAnimationDuration : touchUpAnimationDuration

        floatingView.layer.shouldRasterize = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .allowUserInteraction) { [weak self] in
            self?.layoutIfNeeded()
        } completion: { [weak self] (completed) in

            guard let self = self else { return }

            self.floatingView.layer.shouldRasterize = false
            self.isMovingUpOrDown = false // Disable `inTransition` on animation completion.

            // Handle disabled state on touch down
            if self.hasTouchesEndedInside == true,
               completed,
               isHighlighted,
               !isLevitating,
               let disableOnNextClickWithAlpha = self.disableOnNextClickWithAlpha {
                self.triggerDisableState(disableOnNextClickWithAlpha)
                return
            }

            if completed && isTransitioningToNormalState {
                self.sendTouchEvent?()
                self.sendTouchEvent = nil
            }

            if isHighlighted != self.isHighlighted { // if present state is not the same. request for state change.
                self.updateButton(isHighlighted: self.isHighlighted, isLevitating: isLevitating)
                return
            }
        }
    }

    func updateStateAndApplyHaptic(isHighlighted: Bool) {
        // Apply haptic only for state change to highlighted.
        guard isHighlighted,
              self.isHighlighted != isHighlighted else {
            return
        }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: Disable State Methods
private extension PopFloatingButton {
    func triggerDisableState(_ disableWithAlpha: Bool) {
        changeToDisabled(withAlpha: disableWithAlpha)

        sendTouchEvent?()
        sendTouchEvent = nil
        disableOnNextClickWithAlpha = nil
    }

    func changeToDisabled(withAlpha: Bool) {
        isInDisabledState = true
        isEnabled = false
        updateConstraintsForTouchDown(isLevitating: false)
        UIView.animate(withDuration: touchDownAnimationDuration, delay: 0, options: .allowUserInteraction) {
            self.layoutIfNeeded()
        } completion: { _ in }

        stopLevitatingMotion()
        endShimmerAnimation()

        customContainer?.updateOnStateChange(state: .disabled(withOpacity: withAlpha))

        guard withAlpha else {
            floatingView.configurePopView(withModel: getDisabledPopViewModel())
            return
        }

        floatingView.alpha = 0.5
        shadowView.alpha = 0.0
    }

    func getDisabledPopViewModel() -> PopView.Model {
        PopView.Model(popEdgeDirection: .bottom(customInclination: getStandardInclination(edgeWidth: model.edgeWidth)), edgeOffSet: model.edgeWidth, backgroundColor: model.disabledBackgroundColor)
    }
}

// MARK: Initial Setup Methods
private extension PopFloatingButton {
    func setup() {
        addSubview(shadowView)
        shadowView.isUserInteractionEnabled = false
        addSubview(floatingView)
        floatingView.isUserInteractionEnabled = false

        shadowView.translatesAutoresizingMaskIntoConstraints = false

        let shadowViewBottomConstraint = shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        self.shadowViewBottomConstraint = shadowViewBottomConstraint

        let shadowViewWidthConstraint = shadowView.widthAnchor.constraint(equalTo: widthAnchor)
        self.shadowViewWidthConstraint = shadowViewWidthConstraint

        NSLayoutConstraint.activate([
            shadowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            shadowView.heightAnchor.constraint(equalTo: floatingView.heightAnchor),
            shadowViewWidthConstraint,
            shadowViewBottomConstraint
        ])

        floatingView.translatesAutoresizingMaskIntoConstraints = false
        let floatingViewTopConstraint = floatingView.topAnchor.constraint(equalTo: topAnchor)
        self.floatingViewTopConstraint = floatingViewTopConstraint
        NSLayoutConstraint.activate([
            floatingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            floatingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            floatingView.heightAnchor.constraint(equalTo: heightAnchor),
            floatingViewTopConstraint
        ])

        floatingView.addLayoutGuide(buttonContentLayoutGuide)
        let buttonContentCenterYConstraint = buttonContentLayoutGuide.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor)
        self.buttonContentCenterYConstraint = buttonContentCenterYConstraint
        NSLayoutConstraint.activate([
            buttonContentLayoutGuide.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor),
            buttonContentLayoutGuide.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor),
            buttonContentLayoutGuide.heightAnchor.constraint(equalTo: floatingView.heightAnchor),
            buttonContentCenterYConstraint
        ])

        setCustomContainerView(PopButtonContainerView())
    }

    func normalStateSetup() {
        // Dept. effect on top layer.
        reconfigurePopViews()
        updateButton(isHighlighted: isHighlighted, animate: false)
    }

    func reconfigurePopViews() {
        let customInclination = getStandardInclination(edgeWidth: model.edgeWidth)
        guard customInclination != 0 else { return }

        floatingView.configurePopView(
            withModel: PopView.Model(
                popEdgeDirection: .bottom(customInclination: customInclination),
                edgeOffSet: model.edgeWidth,
                backgroundColor: model.backgroundColor,
                horizontalEdgeColor: model.customEdgeColor,
                centerBorderColors: EdgeColors(color: model.borderColor),
                borderWidth: model.borderWidth
            )
        )

        shadowView.configurePopView(withModel: PopView.Model(
                                        popEdgeDirection: .bottom(customInclination: customInclination),
                                        customEdgeVisibility: EdgeVisibilityModel(hideBottomEdge: true),
                                        edgeOffSet: model.edgeWidth,
                                        backgroundColor: model.shadowColor))
    }

    func getStandardInclination(edgeWidth: CGFloat) -> (CGFloat) {
        // 50 & 15 are the constants taken from design spec to fix the inclination.
        let leftPadding = (bounds.height / 50.0) * 15.0
        let inclination = (leftPadding / edgeWidth)

        return inclination
    }
}
