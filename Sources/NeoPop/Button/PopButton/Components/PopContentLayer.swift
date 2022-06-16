//
//  PopContentLayer.swift
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

final class PopContentLayer: CAShapeLayer {
    enum Position {
        case top
        case bottom
        case left
        case right
    }

    private var topBorder: CAShapeLayer?
    private var bottomBorder: CAShapeLayer?
    private var leftBorder: CAShapeLayer?
    private var rightBorder: CAShapeLayer?

    override func layoutSublayers() {
        super.layoutSublayers()
        topBorder?.frame = bounds
        bottomBorder?.frame = bounds
        leftBorder?.frame = bounds
        rightBorder?.frame = bounds
    }
}

// MARK: Public Methods
extension PopContentLayer {
    func configureBorders(withModel model: PopContentLineModel, for position: Position) {
        let linePath = UIBezierPath()
        linePath.move(to: model.start)
        linePath.addLine(to: model.end)
        linePath.close()

        let border: CAShapeLayer
        switch position {
        case .top:
            if topBorder == nil {
                topBorder = createLayer()
            }
            border = topBorder!
        case .bottom:
            if bottomBorder == nil {
                bottomBorder = createLayer()
            }
            border = bottomBorder!
        case .left:
            if leftBorder == nil {
                leftBorder = createLayer()
            }
            border = leftBorder!
        case .right:
            if rightBorder == nil {
                rightBorder = createLayer()
            }
            border = rightBorder!
        }

        border.isHidden = false
        border.frame = bounds
        border.fillColor = model.color.cgColor
        border.strokeColor = model.color.cgColor
        border.lineWidth = model.borderWidth
        border.path = linePath.cgPath
    }

    func configureBorders(with borderModels: [PopContentLineModel]) {
        let listOfPositions: [Position] = [.left, .right, .top, .bottom]
        for (index, borderModel) in borderModels.enumerated() {
            guard let position = listOfPositions[safe: index] else {
                continue
            }

            configureBorders(withModel: borderModel, for: position)
        }
    }

    func hideBorder(on position: Position) {
        var border: CAShapeLayer?
        switch position {
        case .top:
            border = topBorder
        case .bottom:
            border = bottomBorder
        case .left:
            border = leftBorder
        case .right:
            border = rightBorder
        }

        border?.isHidden = true
    }

    func hideAllBorders() {
        [topBorder, bottomBorder, leftBorder, rightBorder].forEach { $0?.isHidden = true }
    }
}

// MARK: Private Methods
private extension PopContentLayer {
    func createLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.masksToBounds = true
        layer.fillColor = UIColor.clear.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        addSublayer(layer)
        return layer
    }
}
