//
//  TopLeftButtonDrawManager.swift
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

struct TopLeftButtonDrawManager: PopButtonDrawable {
    static func constraintsForCornerTailView(on buttonContentView: UIView, cornerView: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(cornerView.topAnchor.constraint(equalTo: buttonContentView.topAnchor))
        constraints.append(cornerView.leadingAnchor.constraint(equalTo: buttonContentView.leadingAnchor))
        return constraints
    }

    static func getCornerTailDirection(_ position: PopButton.Position) -> PopButton.CornerShape {
        var shape: PopButton.CornerShape = .none
        switch position {
        case .leftEdge, .bottomLeft:
            shape = .leftToBottomRightCorner(usedHorizontally: false)
        case .topEdge, .topRight:
            shape = .rightToTopLeftCorner(usedHorizontally: true)
        default:
            shape = .none
        }
        return shape
    }

    static func updateCenterContentLayerDrawingPoints(point1: inout CGPoint,
                                                      point2: inout CGPoint,
                                                      point3: inout CGPoint,
                                                      point4: inout CGPoint,
                                                      viewFrame: CGRect,
                                                      configModel: PopButton.Model) { }

    static func fineTuneBorderPoints(leftBorder: inout PopContentLineModel?,
                                     rightBorder: inout PopContentLineModel?,
                                     bottomBorder: inout PopContentLineModel?,
                                     topBorder: inout PopContentLineModel?) {

        let borderWidth = leftBorder?.borderWidth ?? rightBorder?.borderWidth ?? topBorder?.borderWidth ?? bottomBorder?.borderWidth ?? .zero
        if var param = topBorder {
            let pointSource = CGPoint(x: param.start.x, y: param.start.y + borderWidth/2)
            let pointDest = CGPoint(x: param.end.x, y: param.end.y + borderWidth/2)
            param.start = pointSource
            param.end = pointDest
            topBorder = param
        }
        if var param = leftBorder {
            let pointSource = CGPoint(x: param.start.x + borderWidth/2, y: param.start.y + borderWidth)
            let pointDest = CGPoint(x: param.end.x + borderWidth/2, y: param.end.y)
            param.start = pointSource
            param.end = pointDest
            leftBorder = param
        }
        if var param = bottomBorder {
            let pointSource = CGPoint(x: param.start.x + borderWidth, y: param.start.y - borderWidth/2)
            let pointDest = CGPoint(x: param.end.x, y: param.end.y  - borderWidth/2)
            param.start = pointSource
            param.end = pointDest
            bottomBorder = param
        }
        if var param = rightBorder {
            let pointSource = CGPoint(x: param.start.x - borderWidth/2, y: param.start.y)
            let pointDest = CGPoint(x: param.end.x - borderWidth/2, y: param.end.y)
            param.start = pointSource
            param.end = pointDest
            rightBorder = param
        }
    }

    static func getPointsForStaticBorders(for colors: (horizontal: UIColor?, vertical: UIColor?)?, viewFrame: CGRect, borderWidth: CGFloat, edgePadding: CGFloat) -> [PopContentLineModel] {

        guard let colors = colors else {
            return []
        }

        var borderParams: [PopContentLineModel] = []

        if let verticalColor = colors.vertical {
            let p1 = CGPoint(x: borderWidth/2, y: 0)
            let p2 = CGPoint(x: borderWidth/2, y: viewFrame.height - edgePadding)
            borderParams.append(PopContentLineModel(start: p1, end: p2, color: verticalColor, borderWidth: borderWidth))
        }

        if let horizontalColor = colors.horizontal {
            let p1 = CGPoint(x: 0, y: borderWidth/2)
            let p2 = CGPoint(x: viewFrame.width -  edgePadding, y: borderWidth/2)
            borderParams.append(PopContentLineModel(start: p1, end: p2, color: horizontalColor, borderWidth: borderWidth))
        }

        return borderParams

    }

    static func getNormalStateViewOffsets(popModel: PopButton.Model) -> UIEdgeInsets {
        let edgePadding = popModel.edgeLength
        return UIEdgeInsets(top: -edgePadding, left: -edgePadding, bottom: edgePadding, right: edgePadding)
    }

    static func buttonCustomInsets(buttonModel: PopButton.Model) -> UIEdgeInsets {

        let position = buttonModel.position
        let padding = buttonModel.edgeLength

        switch position {
        case .bottomEdge, .bottomRight:
            return UIEdgeInsets(top: padding, left: padding, bottom: 0, right: 0)

        case .bottomLeft:
            return UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0)

        case .topRight, .topEdge:
            return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)

        case .rightEdge:
            return UIEdgeInsets(top: padding, left: padding, bottom: 0, right: 0)

        case .leftEdge:
            return UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0)

        case .center:
            return UIEdgeInsets(top: padding, left: padding, bottom: 0, right: 0)

        default:
            return .zero
        }
    }

    static func offsetForContentViewTransition(isPressedState: Bool, buttonModel: PopButton.Model) -> UIEdgeInsets {
        var top: CGFloat = .zero
        var left: CGFloat = .zero
        var right: CGFloat = .zero
        var bottom: CGFloat = .zero

        let edgePadding = buttonModel.edgeLength
        let customInsets = buttonCustomInsets(buttonModel: buttonModel)

        if isPressedState { // BottomRight
            top = -customInsets.top
            right = edgePadding - customInsets.right
            left = -customInsets.left
            bottom = edgePadding - customInsets.bottom

        } else { // TopLeft
            top = edgePadding - customInsets.top
            left = edgePadding - customInsets.left
            right =  -customInsets.right
            bottom =  -customInsets.bottom
        }

        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)

    }

}
