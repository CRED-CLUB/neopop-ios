//
//  BottomRightButtonDrawManager.swift
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

struct BottomRightButtonDrawManager: PopButtonDrawable {
    /*
     * this methods provides the layout constraints for the tail view.
     */
    static func constaintsForCornerTailView(on buttonContentView: UIView, cornerView: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(cornerView.bottomAnchor.constraint(equalTo: buttonContentView.bottomAnchor))
        constraints.append(cornerView.trailingAnchor.constraint(equalTo: buttonContentView.trailingAnchor))
        return constraints
    }

    /*
     * this methods decides direction, position of the above mentioned button tail and draw it.
     */
    static func getCornerTailDirection(_ position: PopButton.Position) -> PopButton.CornerShape {
        var shape: PopButton.CornerShape = .none
        switch position {
        case .bottomEdge, .bottomLeft:
            shape = .leftToBottomRightCorner(usedHorizontally: true)
        case .rightEdge, .topRight:
            shape = .rightToTopLeftCorner(usedHorizontally: false)

        default:
            shape = .none
        }
        return shape
    }

    static func updateCenterContentLayerDrawingPoints( point1: inout CGPoint, point2: inout CGPoint, point3: inout CGPoint, point4: inout CGPoint, viewFrame: CGRect, configModel: PopButton.Model) {

    }

    static func fineTuneBorderPoints(leftBorder: inout (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?, rightBorder: inout (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?, bottomBorder: inout (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?, topBorder: inout (start: CGPoint, end: CGPoint, color: UIColor, borderWidth: CGFloat)?) {

        let borderWidth = leftBorder?.3 ?? rightBorder?.3 ?? topBorder?.3 ?? bottomBorder?.3 ?? .zero

        if var param = bottomBorder {
            let pointSource = CGPoint(x: param.0.x + borderWidth, y: param.0.y - borderWidth / 2)
            let pointDest = CGPoint(x: param.1.x, y: param.1.y - borderWidth / 2)
            param.0 = pointSource
            param.1 = pointDest
            bottomBorder = param
        }
        if var param = rightBorder {
            let pointSource = CGPoint(x: param.0.x - borderWidth / 2, y: param.0.y - borderWidth)
            let pointDest = CGPoint(x: param.1.x - borderWidth / 2, y: param.1.y + borderWidth)
            param.0 = pointSource
            param.1 = pointDest
            rightBorder = param
        }
        /*
         - Modifying the points inorder to keep the border which are non-adjacent to edges inside the view, (to maintain same border width.) The adjacent sides will have borders overlapped with button edges, notice 'clipsToBounds' is 'false'.
         - Applicable to all the cases here.
         */
        if var param = topBorder {
            let pointSource = CGPoint(x: param.0.x, y: param.0.y + borderWidth/2)
            let pointDest = CGPoint(x: param.1.x + borderWidth, y: param.1.y + borderWidth/2)
            param.0 = pointSource
            param.1 = pointDest
            topBorder = param
        }
        if var param = leftBorder {
            let pointSource = CGPoint(x: param.0.x + borderWidth / 2, y: param.0.y)
            let pointDest = CGPoint(x: param.1.x + borderWidth / 2, y: param.1.y)
            param.0 = pointSource
            param.1 = pointDest
            leftBorder = param
        }

    }

    static func getPointsForStaticBorders(for colors: (horizontal: UIColor?, vertical: UIColor?)?, viewFrame: CGRect, borderWidth: CGFloat, edgePadding: CGFloat) -> [(start: CGPoint, destin: CGPoint, color: UIColor, width: CGFloat)] {

        guard let colors = colors else {
            return []
        }
        var borderParams: [(start: CGPoint, destin: CGPoint, color: UIColor, width: CGFloat)] = []
        if let vertColor = colors.vertical {
            let p1 = CGPoint(x: viewFrame.width-borderWidth/2, y: edgePadding)
            let p2 = CGPoint(x: viewFrame.width-borderWidth/2, y: viewFrame.height)
            borderParams.append((start: p1, destin: p2, color: vertColor, width: borderWidth))
        }
        if let horizColor = colors.horizontal {
            let p1 = CGPoint(x: edgePadding, y: viewFrame.height - borderWidth/2)
            let p2 = CGPoint(x: viewFrame.width, y: viewFrame.height - borderWidth/2)
            borderParams.append((start: p1, destin: p2, color: horizColor, width: borderWidth))
        }

        return borderParams
    }

    static func getNormalStateViewOffsets(neopopModel: PopButton.Model) -> UIEdgeInsets {
        let edgePadding = neopopModel.edgeLength
        return UIEdgeInsets(top: edgePadding, left: edgePadding, bottom: -edgePadding, right: -edgePadding)
    }

    static func buttonCustomInsets(buttonModel: PopButton.Model) -> UIEdgeInsets {

        let position = buttonModel.position
        let padding = buttonModel.edgeLength

        switch position {
        case .bottomEdge, .bottomLeft:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding)

        case .leftEdge, .topLeft, .topEdge:
            return UIEdgeInsets(top: 0, left: 0, bottom: padding, right: padding)

        case .topRight, .rightEdge:
            return UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)

        case .center:
            return UIEdgeInsets(top: 0, left: 0, bottom: padding, right: padding)

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

        if isPressedState { // TopLeft
            top = edgePadding - customInsets.top
            left = edgePadding - customInsets.left
            right =  0 - customInsets.right
            bottom =  0 - customInsets.bottom
        } else { // BottomRight
            top = 0 - customInsets.top
            right = edgePadding - customInsets.right
            left = 0 - customInsets.left
            bottom = edgePadding - customInsets.bottom
        }

        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
