//
//  PopSelectionControl.swift
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

open class PopSelectionControl: UIControl {

    private var isTouchDown: Bool = false

    private let contentLayer = CALayer()

    private let imageLayer: CALayer = {
        let layer = CALayer()
        layer.contentsGravity = .resizeAspect
        return layer
    }()

    private(set) public var isSelectedState: Bool = false
    private(set) public var mode: Mode = .dark
    private(set) public var borderWidth: CGFloat = 1

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }

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

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        contentLayer.frame = layer.bounds
        layoutimageLayer(for: layer.bounds)

        setContentCornerRadius()
        setContentBorderWidth()
    }

    // MARK: Configs
    open func configure(mode: Mode) {
        self.mode = mode
        updateComponent()
    }

    open func configureBorderWidth(_ borderWidth: CGFloat) {
        self.borderWidth = borderWidth
        updateComponent()
    }

    open func setSelected(_ selected: Bool) {
        self.isSelectedState = selected
        layer.setNeedsLayout()
        stateDidChange()
    }

    @objc
    fileprivate func touchDown() {
        isTouchDown = true
        layer.setNeedsLayout()
    }

    @objc
    fileprivate func touchUp() {
        isSelectedState.toggle()
        stateDidChange()
        touchEnded()
    }

    @objc
    fileprivate func touchEnded() {
        isTouchDown = false
        layer.setNeedsLayout()
    }

    func layoutimageLayer(for bounds: CGRect) {
        let size = getImageLayerSize()
        let origin = getImageLayerOrigin()
        imageLayer.frame = CGRect(origin: origin, size: size)
    }

    func getBorderWidth() -> CGFloat { 0 }

    func getCornerRadius() -> CGFloat { 0 }

    func getBackgroundColor() -> CGColor? { nil }

    func getImage() -> CGImage? { nil }
}

// MARK: Getter Methods
extension PopSelectionControl {
    func getImageLayerSize() -> CGSize {
        return CGSize(width: contentLayer.frame.width/2, height: contentLayer.frame.height/2)
    }

    func getImageLayerOrigin() -> CGPoint {
        let contentLayerSize = contentLayer.frame.size
        let imageLayerSize = getImageLayerSize()
        return CGPoint(x: (contentLayerSize.width - imageLayerSize.width)/2.0, y: (contentLayerSize.height - imageLayerSize.height)/2.0 )
    }

    func getBorderColor() -> CGColor? {
        switch mode {
        case .light:
            return UIColor.black.cgColor
        case .dark:
            return UIColor.white.cgColor
        case let .custom(selectedModel, unSelectedModel):
            return isSelectedState ? selectedModel.borderColor.cgColor : unSelectedModel.borderColor.cgColor
        }
    }

    func getDarkTickImage() -> UIImage {
        return UIImage(named: ImageConstants.checkBoxTickDark, in: Bundle.module, compatibleWith: nil)!
    }

    func getLightTickImage() -> UIImage {
        return UIImage(named: ImageConstants.checkBoxTickLight, in: Bundle.module, compatibleWith: nil)!
    }

    func setContentCornerRadius() {
        contentLayer.cornerRadius = getCornerRadius()
    }

    func setContentBorderWidth() {
        contentLayer.borderWidth = getBorderWidth()
    }

    func updateComponent() {
        contentLayer.borderColor = getBorderColor()
        contentLayer.backgroundColor = getBackgroundColor()
        setContentBorderWidth()
        setContentCornerRadius()
        imageLayer.contents = getImage()
    }
}

// MARK: Setup Methods
private extension PopSelectionControl {
    func setup() {
        self.setContentCompressionResistancePriority(.init(900), for: .horizontal)
        self.setContentCompressionResistancePriority(.init(900), for: .vertical)
        backgroundColor = .clear
        layer.addSublayer(contentLayer)
        contentLayer.addSublayer(imageLayer)
        contentLayer.masksToBounds = true
        updateComponent()
        addTouchHandlers()
        layer.setNeedsLayout()
    }

    func addTouchHandlers() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside])
        addTarget(self, action: #selector(touchEnded), for: [.touchDragExit, .touchCancel])
    }

    func stateDidChange() {
        updateComponent()
        sendActions(for: .valueChanged)
    }
}
