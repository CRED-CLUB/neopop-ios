//
//  PopView+Model.swift
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

public extension PopView {

    struct Model: Equatable {
        public static func == (lhs: PopView.Model, rhs: PopView.Model) -> Bool {
            lhs.popEdgeDirection == rhs.popEdgeDirection &&
                lhs.customEdgeVisibility == rhs.customEdgeVisibility &&
                lhs.customBorderVisibility == rhs.customBorderVisibility &&
                lhs.edgeOffSet == rhs.edgeOffSet &&
                lhs.backgroundColor == rhs.backgroundColor &&
                lhs.verticalEdgeColor == rhs.verticalEdgeColor &&
                lhs.horizontalEdgeColor == rhs.horizontalEdgeColor &&
                lhs.verticalBorderColors == rhs.verticalBorderColors &&
                lhs.horizontalBorderColors == rhs.horizontalBorderColors &&
                lhs.clipsToOffSetWidth == rhs.clipsToOffSetWidth &&
                lhs.clipsToOffSetHeight == rhs.clipsToOffSetHeight &&
                lhs.modelIdentifier == rhs.modelIdentifier &&
                lhs.borderWidth == rhs.borderWidth
        }

        /// Direction of edge of the pop view.
        public var popEdgeDirection: EdgeDirection

        /// Change the visibility of the available edges.
        public var customEdgeVisibility: EdgeVisibilityModel?

        /// Change the visibility of the border.
        public var customBorderVisibility: EdgeVisibilityModel?

        /// depth of the edge.
        public var edgeOffSet: CGFloat

        /// Background color of the view.
        public var backgroundColor: UIColor

        /// Color of the vertical edge in the view. (either of left/right). Optional input as it will be derived from bg color
        public var verticalEdgeColor: UIColor

        /// Color of the horizontal edge in the view. (either of top/bottom). Optional input as it will be derived from bg color
        public var horizontalEdgeColor: UIColor

        /// Color of the vertical/horizontal edge borders. (customizable for each side of the edge)
        public var verticalBorderColors: EdgeColors?
        public var horizontalBorderColors: EdgeColors?
        public var centerBorderColors: EdgeColors?

        /// Whether clipping needs to be done to the vertical/horizontal edge (clipping position options are available here)
        public var clipsToOffSetWidth: EdgeClipping = .none
        public var clipsToOffSetHeight: EdgeClipping = .none

        /// Delegate to handle the callbacks. customisation in the drawing path can be achieved through this delegate.
        public weak var delegate: PopViewDrawable?

        /// Identifier for model/view for reference
        public var modelIdentifier: String?

        /// width for the border
        public var borderWidth: CGFloat = 0.0

        /// initialization
        public init(popEdgeDirection: EdgeDirection,
                    customEdgeVisibility: EdgeVisibilityModel? = nil,
                    customBorderVisibility: EdgeVisibilityModel? = nil,
                    edgeOffSet: CGFloat = 3,
                    backgroundColor: UIColor,
                    verticalEdgeColor: UIColor? = nil,
                    horizontalEdgeColor: UIColor? = nil,
                    verticalBorderColors: EdgeColors? = nil,
                    horizontalBorderColors: EdgeColors? = nil,
                    centerBorderColors: EdgeColors? = nil,
                    clipsToOffSetWidth: EdgeClipping = .none,
                    clipsToOffSetHeight: EdgeClipping = .none,
                    delegate: PopViewDrawable? = nil,
                    modelIdentifier: String? = nil,
                    borderWidth: CGFloat = 0.0) {

            self.popEdgeDirection = popEdgeDirection
            self.customEdgeVisibility = customEdgeVisibility
            self.customBorderVisibility = customBorderVisibility
            self.edgeOffSet = edgeOffSet
            self.backgroundColor = backgroundColor
            self.verticalEdgeColor = verticalEdgeColor ?? PopHelper.verticalEdgeColor(for: backgroundColor)
            self.horizontalEdgeColor = horizontalEdgeColor ?? PopHelper.horizontalEdgeColor(for: backgroundColor)
            self.verticalBorderColors = verticalBorderColors
            self.horizontalBorderColors = horizontalBorderColors
            self.centerBorderColors = centerBorderColors
            self.clipsToOffSetWidth = clipsToOffSetWidth
            self.clipsToOffSetHeight = clipsToOffSetHeight
            self.delegate = delegate
            self.modelIdentifier = modelIdentifier
            self.borderWidth = borderWidth

        }
    }

}
