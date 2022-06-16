//
//  PopButtonDrawable.swift
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

protocol PopButtonDrawable {
    // For tail view.
    static func constaintsForCornerTailView(on buttonContentView: UIView, cornerView: UIView) -> [NSLayoutConstraint]

    static func getCornerTailDirection(_ position: PopButton.Position) -> PopButton.CornerShape

    // For center layer
    static func updateCenterContentLayerDrawingPoints(point1: inout CGPoint, point2: inout CGPoint, point3: inout CGPoint, point4: inout CGPoint, viewFrame: CGRect, configModel: PopButton.Model)

    static func fineTuneBorderPoints(leftBorder: inout PopContentLineModel?, rightBorder: inout PopContentLineModel?, bottomBorder: inout PopContentLineModel?, topBorder: inout PopContentLineModel?)

    // Static borders.
    static func getPointsForStaticBorders(for colors: (horizontal: UIColor?, vertical: UIColor?)?, viewFrame: CGRect, borderWidth: CGFloat, edgePadding: CGFloat) -> [PopContentLineModel]

    // Normal State Edge views
    static func getNormalStateViewOffsets(neopopModel: PopButton.Model) -> UIEdgeInsets

    // For center view
    static func buttonCustomInsets(buttonModel: PopButton.Model) -> UIEdgeInsets

    static func offsetForContentViewTransition(isPressedState: Bool, buttonModel: PopButton.Model) -> UIEdgeInsets

}
