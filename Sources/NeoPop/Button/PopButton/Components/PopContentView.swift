//
//  PopContentView.swift
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

final class PopContentView: UIView {

    private var isDisabled: Bool = false
    private var neoButttonBackgroundColor: UIColor {
        config?.backgroundColor ?? UIColor.white
    }

    private var contentLayer: PopContentLayer {
        layer as! PopContentLayer
    }

    var drawingManager: PopButtonDrawable.Type?
    var config: PopButton.Model?

    override var bounds: CGRect {
        didSet {
            guard bounds != oldValue else {
                return
            }
            drawContents(isDisabled: isDisabled)
        }
    }

    override class var layerClass: AnyClass {
        PopContentLayer.self
    }

}

extension PopContentView {
    func drawContents(isDisabled: Bool) {
        guard let config = config else {
            return
        }
        self.isDisabled = isDisabled

        let contentLayerBorderColor: EdgeColors? = isDisabled ? nil : config.buttonFaceBorderColor
        let contentLayerBGColor: CGColor = isDisabled ? UIColor.fromHex("8A8A8A").cgColor : neoButttonBackgroundColor.cgColor

        let originX: CGFloat = 0
        let originY: CGFloat = 0

        let frameWidth = bounds.width
        let frameHeight = bounds.height

        var point1: CGPoint = .zero
        var point2: CGPoint = .zero
        var point3: CGPoint = .zero
        var point4: CGPoint = .zero
        var point5: CGPoint = .zero

        point1 = CGPoint(x: originX, y: originY)
        point2 = CGPoint(x: originX, y: frameHeight)
        point3 = CGPoint(x: frameWidth, y: frameHeight)
        point4 = CGPoint(x: frameWidth, y: originY)

        drawingManager?.updateCenterContentLayerDrawingPoints(point1: &point1, point2: &point2, point3: &point3, point4: &point4, viewFrame: bounds, configModel: config)

        point5 = point1

        let linePath = UIBezierPath()
        linePath.move(to: point1)
        linePath.addLine(to: point2)
        linePath.addLine(to: point3)
        linePath.addLine(to: point4)
        linePath.addLine(to: point5)
        linePath.close()
        contentLayer.fillColor = contentLayerBGColor
        contentLayer.path = linePath.cgPath
        clipsToBounds = false

        let borderWidth: CGFloat = config.borderWidth

        // Draw borders to center part.
        var leftBorder: (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?
        var rightBorder: (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?
        var bottomBorder: (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?
        var topBorder: (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?

        // Prepare the border edge points
        if let color = contentLayerBorderColor?.left {
            leftBorder = (start: point1, end: point2, color: color, borderWidth: borderWidth)
        }
        if let color = contentLayerBorderColor?.bottom {
            bottomBorder = (start: point2, end: point3, color: color, borderWidth: borderWidth)
        }
        if let color = contentLayerBorderColor?.right {
            rightBorder = (start: point3, end: point4, color: color, borderWidth: borderWidth)
        }
        if let color = contentLayerBorderColor?.top {
            topBorder = (start: point4, end: point5, color: color, borderWidth: borderWidth)
        }

        // get border points.
        drawingManager?.fineTuneBorderPoints(leftBorder: &leftBorder, rightBorder: &rightBorder, bottomBorder: &bottomBorder, topBorder: &topBorder)

        configureBorder(leftBorder, position: .left)
        configureBorder(rightBorder, position: .right)
        configureBorder(topBorder, position: .top)
        configureBorder(bottomBorder, position: .bottom)
    }

    func configureBorder(_ param: (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?, position: PopContentLayer.Position) {
        guard let param = param else {
            contentLayer.hideBorder(on: position)
            return
        }

        contentLayer.configureBorders(withModel: PopContentLayer.BorderModel(start: param.start, end: param.end, color: param.color, borderWidth: param.borderWidth), for: position)
    }
}
