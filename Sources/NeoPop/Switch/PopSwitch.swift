//
//  PopSwitch.swift
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

/// It is a standard Switch Control which toggles from `off` to `on` and vice versa
/// when we click on it
///
/// It's appearance will change based on ``PopSwitch/mode-swift.property``
///
/// Incase of custom mode, It has two states which defines the custom user defined appearance from
/// 1. off state
/// 2. on state
///
/// It has a default ``intrinsicContentSize``, so we can skip adding size constraints
///
/// Also the change in state can be observed by adding a target using ``UIControl/Event/valueChanged``
open class PopSwitch: UIControl {
    private var trackTopBottomPadding: CGFloat = 0 {
        didSet {
            layer.setNeedsLayout()
        }
    }

    private var contentLeadingTrailingPadding: CGFloat = 0 {
        didSet {
            layer.setNeedsLayout()
        }
    }

    private var thumbPadding: CGFloat = 1 {
        didSet {
            layer.setNeedsLayout()
        }
    }

    private lazy var trackLayer = CALayer()
    private lazy var innerLayer = CALayer()

    private lazy var thumbLayer: CALayer = {
        let layer = CALayer()
        layer.contentsGravity = .resizeAspect
        return layer
    }()

    private lazy var thumbCenterLayer: CALayer = {
        let layer = CALayer()
        layer.contentsGravity = .resizeAspect
        return layer
    }()

    private var leftImage: UIImage?
    private var rightImage: UIImage?

    private lazy var contentsLayer = CALayer()

    private var isTouchDown: Bool = false
    
    /// It can be used to know whether the switch is active or not
    private(set) public var isOn: Bool = false
    
    /// It is used to configure the appearance of the ``PopSwitch``
    private(set) public var mode: Mode = .dark

    // MARK: initializers
    public convenience init() {
        self.init(frame: .zero)
        frame.size = intrinsicContentSize
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 52, height: 31)
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        layoutTrackLayer(for: layer.bounds)
        layoutThumbLayer(for: layer.bounds)
        layoutThumbCenterLayer(for: layer.bounds)
        contentsLayer.frame = layer.bounds
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.setNeedsLayout()
    }

    // MARK: Configure
    
    /// Use this method to update the mode of the control
    /// - Parameter mode: mode of the control
    ///
    /// refer ``PopSwitch/Mode-swift.enum`` for list of modes
    ///
    open func configureMode(_ mode: Mode) {
        self.mode = mode
        updateComponents()
    }
    
    /// This method sets the selected and unselected state images
    /// - Parameters:
    ///   - left: unselected state image
    ///   - right: selected state image
    open func setThumbImages(left: UIImage, right: UIImage) {
        leftImage = left
        rightImage = right
        thumbCenterLayer.isHidden = true
        updateComponents()
    }
    
    /// Use this method to toggle the selected state of the switch
    /// - Parameters:
    ///   - on: a new boolean value
    ///   - animated: should animate the switch state changes
    open func setOn(_ on: Bool, animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        isOn = on
        layer.setNeedsLayout()
        stateDidChange()
        CATransaction.commit()
    }

    @objc
    private func swipeLeftRight(_ gesture: UISwipeGestureRecognizer) {
        let canLeftSwipe = isOn && gesture.direction == .left
        let canRightSwipe = !isOn && gesture.direction == .right
        guard canLeftSwipe || canRightSwipe else { return }
        touchUp()
    }

    @objc
    private func touchDown() {
        isTouchDown = true
        layer.setNeedsLayout()
    }

    @objc
    private func touchUp() {
        isOn.toggle()
        stateDidChange()
        touchEnded()
    }

    @objc
    private func touchEnded() {
        isTouchDown = false
        layer.setNeedsLayout()
    }
}

// MARK: Layer Layout Methods
private extension PopSwitch {
    func layoutTrackLayer(for bounds: CGRect) {
        trackLayer.frame = bounds.insetBy(dx: trackTopBottomPadding, dy: trackTopBottomPadding)
    }

    func layoutInnerLayer(for bounds: CGRect) {
        let inset = 1.0 + trackTopBottomPadding
        let isInnerHidden = isOn || (isTouchDown)

        innerLayer.frame = isInnerHidden
            ? CGRect(origin: trackLayer.position, size: .zero)
            : bounds.insetBy(dx: inset, dy: inset)
    }

    func layoutThumbLayer(for bounds: CGRect) {
        let size = getThumbSize()
        let origin = getThumbOrigin(for: size.width)
        thumbLayer.frame = CGRect(origin: origin, size: size)
    }

    func layoutThumbCenterLayer(for bounds: CGRect) {
        let size = getThumbCenterLayerSize()
        let origin = getThumbCenterLayerOrigin()
        thumbCenterLayer.frame = CGRect(origin: origin, size: size)
    }

    func stateDidChange() {
        updateComponents()
        sendActions(for: .valueChanged)
    }
}

// MARK: Setter Methods
private extension PopSwitch {
    func setBorderColor() {
        self.thumbLayer.borderColor = getBorderColor()
    }

    func setThumbColor() {
        self.thumbLayer.backgroundColor = getThumbColor()
    }

    func setThumbCenterColor() {
        self.thumbCenterLayer.backgroundColor = getThumbCenterColor()
    }

    func setImage() {
        self.thumbLayer.contents = getImage()
        self.layoutIfNeeded()
    }
}

// MARK: Getter Methods
private extension PopSwitch {
    func getThumbSize() -> CGSize {
        let height = bounds.height - 2 * (1.0 + thumbPadding)
        let width = height
        return CGSize(width: width, height: height)
    }

    func getThumbCenterLayerSize() -> CGSize {
        let height = bounds.height - 2 * (getCenterThumbPadding() + thumbPadding)
        let width = height
        return CGSize(width: width, height: height)
    }

    func getThumbOrigin(for width: CGFloat) -> CGPoint {
        let inset = 1.0 + thumbPadding
        let x = isOn ? bounds.width - width - inset : inset
        return CGPoint(x: x, y: inset)
    }

    func getThumbCenterLayerOrigin() -> CGPoint {
        let thumbSize = getThumbSize()
        let thumbCenterLayerSize = getThumbCenterLayerSize()
        return CGPoint(x: (thumbSize.width - thumbCenterLayerSize.width)/2.0, y: (thumbSize.height - thumbCenterLayerSize.height)/2.0 )
    }

    func getCenterThumbPadding() -> CGFloat {
        return thumbLayer.frame.width/3
    }

    func getImage() -> CGImage? {
        !isOn ? leftImage?.cgImage : rightImage?.cgImage
    }

    func getBackgroundColor() -> CGColor? {
        let darkGreenColor = ColorHelper.darkGreenColor
        switch mode {
        case .light:
            return isOn ? darkGreenColor.cgColor : UIColor.white.cgColor
        case .dark:
            return isOn ? darkGreenColor.cgColor : UIColor.black.cgColor
        case let .custom(offStateModel, onStateModel):
            return isOn ? onStateModel.backgroundColor.cgColor : offStateModel.backgroundColor.cgColor

        }
    }

    func getBorderColor() -> CGColor? {
        switch mode {
        case .light:
            return UIColor.black.cgColor
        case .dark:
            return UIColor.white.cgColor
        case let .custom(offStateModel, onStateModel):
            return isOn ? onStateModel.borderColor.cgColor : offStateModel.borderColor.cgColor
        }
    }

    func getThumbColor() -> CGColor? {
        let brightGreenColor = ColorHelper.brightGreenColor
        switch mode {
        case .light:
            return isOn ? brightGreenColor.cgColor : ColorHelper.popSwitchOffColor.cgColor
        case .dark:
            return isOn ? brightGreenColor.cgColor : UIColor.white.cgColor
        case let .custom(offStateModel, onStateModel):
            return isOn ? onStateModel.thumbBoundaryColor.cgColor : offStateModel.thumbBoundaryColor.cgColor
        }
    }

    func getThumbCenterColor() -> CGColor? {
        switch mode {
        case .light:
            return UIColor.white.cgColor
        case .dark:
            return isOn ? UIColor.white.cgColor : ColorHelper.popSwitchOffColor.cgColor
        case let .custom(offStateModel, onStateModel):
            return isOn ? onStateModel.thumbCenterColor.cgColor : offStateModel.thumbCenterColor.cgColor
        }
    }
}

// MARK: Setup Methods
private extension PopSwitch {
    func setup() {
        setContentCompressionResistancePriority(.init(900), for: .horizontal)
        setContentCompressionResistancePriority(.init(900), for: .vertical)
        backgroundColor = .clear
        layer.addSublayer(trackLayer)
        layer.addSublayer(innerLayer)
        layer.addSublayer(contentsLayer)
        layer.addSublayer(thumbLayer)
        thumbLayer.addSublayer(thumbCenterLayer)
        trackLayer.borderWidth = 1.0
        contentsLayer.masksToBounds = true
        updateComponents()
        addTouchHandlers()
        layer.setNeedsLayout()
    }

    func updateComponents() {
        setThumbColor()
        setThumbCenterColor()
        setBorderColor()
        setImage()
        trackLayer.borderColor = getBorderColor()
        trackLayer.backgroundColor = getBackgroundColor()
    }

    func addTouchHandlers() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside])
        addTarget(self, action: #selector(touchEnded), for: [.touchDragExit, .touchCancel])

        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRight(_:)))
        leftSwipeGesture.direction = [.left]
        addGestureRecognizer(leftSwipeGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRight(_:)))
        rightSwipeGesture.direction = [.right]
        addGestureRecognizer(rightSwipeGesture)
    }
}
