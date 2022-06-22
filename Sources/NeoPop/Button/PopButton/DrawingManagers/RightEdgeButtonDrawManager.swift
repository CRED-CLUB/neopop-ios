//
//  RightEdgeButtonDrawManager.swift
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

struct RightEdgeButtonDrawManager: PopButtonDrawable {
    static func constraintsForCornerTailView(on buttonContentView: UIView, cornerView: UIView) -> [NSLayoutConstraint] {
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
        case .right(let inclinationOffset):
            inclination = inclinationOffset ?? 1.0
        default:
            return
        }

        let customSlope = min(viewFrame.width/2, configModel.edgeLength * (inclination))

        point1 = CGPoint(x: point1.x, y: customSlope)
        point2 = CGPoint(x: point2.x, y: point2.y - customSlope)
    }

    static func fineTuneBorderPoints(leftBorder: inout PopContentLineModel?,
                                     rightBorder: inout PopContentLineModel?,
                                     bottomBorder: inout PopContentLineModel?,
                                     topBorder: inout PopContentLineModel?) { }

    static func getPointsForStaticBorders(for colors: (horizontal: UIColor?, vertical: UIColor?)?, viewFrame: CGRect, borderWidth: CGFloat, edgePadding: CGFloat) -> [PopContentLineModel] {
        return []
    }

    static func getNormalStateViewOffsets(popModel: PopButton.Model) -> UIEdgeInsets {
        let edgePadding = popModel.edgeLength
        return UIEdgeInsets(top: 0, left: edgePadding, bottom: 0, right: -edgePadding)
    }

    static func buttonCustomInsets(buttonModel: PopButton.Model) -> UIEdgeInsets {
        return .zero
    }

    static func offsetForContentViewTransition(isPressedState: Bool, buttonModel: PopButton.Model) -> UIEdgeInsets {

        var left: CGFloat = .zero
        var right: CGFloat = .zero

        let edgePadding = buttonModel.edgeLength
        let customInsets = buttonCustomInsets(buttonModel: buttonModel)

        if isPressedState { // Left
            left = edgePadding - customInsets.left
            right =  -customInsets.right
        } else { // Right
            right = edgePadding - customInsets.right
            left = -customInsets.left
        }

        return UIEdgeInsets(top: .zero, left: left, bottom: .zero, right: right)

    }

}
