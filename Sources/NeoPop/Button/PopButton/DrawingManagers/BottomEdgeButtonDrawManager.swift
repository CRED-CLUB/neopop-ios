//
//  BottomEdgeButtonDrawManager.swift
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

struct BottomEdgeButtonDrawManager: PopButtonDrawable {
    static func constaintsForCornerTailView(on buttonContentView: UIView, cornerView: UIView) -> [NSLayoutConstraint] {
        return []
    }

    static func getCornerTailDirection(_ position: PopButton.Position) -> PopButton.CornerShape {
        return .none
    }

    static func updateCenterContentLayerDrawingPoints(point1: inout CGPoint,
                                                      point2: inout CGPoint,
                                                      point3: inout CGPoint,
                                                      point4: inout CGPoint,
                                                      viewFrame: CGRect,
                                                      configModel: PopButton.Model) {

        var inclination: CGFloat = 1.0
        switch configModel.direction {
        case .bottom(let inclinationOffset):
            inclination = inclinationOffset ?? 1.0
        default:
            return
        }

        let customSlope = min(viewFrame.width/2, configModel.edgeLength * (inclination))

        point1 = CGPoint(x: customSlope, y: point1.y)
        point4 = CGPoint(x: viewFrame.width - customSlope, y: point4.y)
    }

    static func fineTuneBorderPoints(leftBorder: inout PopContentLineModel?,
                                     rightBorder: inout PopContentLineModel?,
                                     bottomBorder: inout PopContentLineModel?,
                                     topBorder: inout PopContentLineModel?) {

        let borderWidth = leftBorder?.borderWidth ?? rightBorder?.borderWidth ?? topBorder?.borderWidth ?? bottomBorder?.borderWidth ?? .zero

        if var param = leftBorder {
            let pointSource = CGPoint(x: param.start.x, y: param.start.y + borderWidth/2)
            let pointDest = CGPoint(x: param.end.x, y: param.end.y )
            param.start = pointSource
            param.end = pointDest
            leftBorder = param
        }

        if var param = bottomBorder {
            let pointSource = CGPoint(x: param.start.x, y: param.start.y - borderWidth/2)
            let pointDest = CGPoint(x: param.end.x, y: param.end.y - borderWidth/2)
            param.start = pointSource
            param.end = pointDest
            bottomBorder = param
        }

        if var param = rightBorder {
            let pointSource = CGPoint(x: param.start.x, y: param.start.y)
            let pointDest = CGPoint(x: param.end.x, y: param.end.y + borderWidth/2)
            param.start = pointSource
            param.end = pointDest
            rightBorder = param
        }

        if var param = topBorder {
            let pointSource = CGPoint(x: param.start.x, y: param.start.y + borderWidth/2)
            let pointDest = CGPoint(x: param.end.x, y: param.end.y + borderWidth/2)
            param.start = pointSource
            param.end = pointDest
            topBorder = param
        }

    }

    static func getPointsForStaticBorders(for colors: (horizontal: UIColor?, vertical: UIColor?)?, viewFrame: CGRect, borderWidth: CGFloat, edgePadding: CGFloat) -> [PopContentLineModel] {
        return []
    }

    static func getNormalStateViewOffsets(neopopModel: PopButton.Model) -> UIEdgeInsets {
        let edgePadding = neopopModel.edgeLength
        return UIEdgeInsets(top: edgePadding, left: 0, bottom: -edgePadding, right: 0)
    }

    static func buttonCustomInsets(buttonModel: PopButton.Model) -> UIEdgeInsets {
        return .zero
    }

    static func offsetForContentViewTransition(isPressedState: Bool, buttonModel: PopButton.Model) -> UIEdgeInsets {

        var top: CGFloat = .zero
        var bottom: CGFloat = .zero

        let edgePadding = buttonModel.edgeLength
        let customInsets = buttonCustomInsets(buttonModel: buttonModel)

        if isPressedState { // Top
            top = edgePadding - customInsets.top
            bottom =  -customInsets.bottom
        } else { // Bottom
            top = -customInsets.top
            bottom = edgePadding - customInsets.bottom
        }

        return UIEdgeInsets(top: top, left: .zero, bottom: bottom, right: .zero)

    }

}
