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
    /// `floatMovementRatio` & `shadowMovementRatio` represents what % of the shadow height should be covered
    /// by float view and shadow while animating.
    /// `floatMovementRatio + shadowMovementRatio` should be 1.0
    /// default behaviour is 50% & 50%
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

    private var disableWithAlpha: Bool = false
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
            reconfigureNeopopViews()
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

    func configureButtonContent(withModel model: PopButtonContainerView.Model) {
        guard let container = customContainer as? PopButtonContainerView else { return }
        container.configureView(withModel: model)
    }

    func setButtonToDisable(onNextClick: Bool = false, disableWithAlpha: Bool = false) {

        guard !isInDisabledState else {
            return
        }

        guard !onNextClick else {
            self.disableWithAlpha = disableWithAlpha
            return
        }

        // Change to disabled
        changeToDisabled(withAlpha: disableWithAlpha)
    }

    func resetButtonToEnableState() {
        disableWithAlpha = false
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
    func setCustomContainerView(_ view: PopButtonCustomContainerDrawable) {
        customContainer = view
        floatingView.addSubview(view)
        view.fill(in: buttonContentLayoutGuide)
    }

    func removeCustomContainer() {
        customContainer?.removeFromSuperview()
    }
}

// MARK: Levitation Methods
public extension PopFloatingButton {
    func startLevitatingMotion() {
        invalidateTimer()

        let timeDuration = TimeInterval(2.5 * levitatingAnimationDuration)
        levitationTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)

        DispatchQueue.main.async {
            self.timerFired()
        }
    }

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
    func startShimmerAnimation(repeatCount: Float = .infinity, startDelay: CGFloat = 0) {
        shimmerDelayTimer?.invalidate()
        shimmerDelayTimer = Timer.scheduledTimer(withTimeInterval: startDelay, repeats: false, block: { [weak self] (_) in
            guard let self = self else { return }
            self.floatingView.startShimmer(repeatCount: repeatCount, shimmerModel: self.model.shimmerModel)
        })
    }

    func setShimmerModel(_ shimmerModel: PopShimmerModel) {
        self.model.shimmerModel = shimmerModel
    }

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

        if hasTouchesEndedInside && !isHighlighted && !isLevitating && disableWithAlpha {
            triggerDisableState(disableWithAlpha)
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
            updateStateAndApplyHaptic(isHighligted: isHighlighted)
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
               self.disableWithAlpha {
                self.triggerDisableState(self.disableWithAlpha)
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

    func updateStateAndApplyHaptic(isHighligted: Bool) {
        // Apply haptic only for state change to highlighted.
        guard isHighligted,
              self.isHighlighted != isHighligted else {
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
        self.disableWithAlpha = false
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
        PopView.Model(neoPopEdgeDirection: .bottom(customInclination: getStandardInclination(edgeWidth: model.edgeWidth)), edgeOffSet: model.edgeWidth, backgroundColor: model.disabledButtonColor)
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
        reconfigureNeopopViews()
        updateButton(isHighlighted: isHighlighted, animate: false)
    }

    func reconfigureNeopopViews() {
        let customInclination = getStandardInclination(edgeWidth: model.edgeWidth)
        guard customInclination != 0 else { return }

        floatingView.configurePopView(
            withModel: PopView.Model(
                neoPopEdgeDirection: .bottom(customInclination: customInclination),
                edgeOffSet: model.edgeWidth,
                backgroundColor: model.backgroundColor,
                horizontalEdgeColor: model.customEdgeColor,
                centerBorderColors: EdgeColors(color: model.borderColor),
                borderWidth: model.borderWidth
            )
        )

        shadowView.configurePopView(withModel: PopView.Model(
                                        neoPopEdgeDirection: .bottom(customInclination: customInclination),
                                        customEdgeVisibility: EdgeVisibilityModel(hideBottomEdge: true),
                                        edgeOffSet: model.edgeWidth,
                                        backgroundColor: model.shadowColor))
    }

    func getStandardInclination(edgeWidth: CGFloat) -> (CGFloat) {
        // 50 & 15 are the constants taken from design spec to fix the inclination.
        let leftPadding = (bounds.height / 50.0) * 15.0
        let inclinParam = (leftPadding / edgeWidth)

        return inclinParam
    }
}
