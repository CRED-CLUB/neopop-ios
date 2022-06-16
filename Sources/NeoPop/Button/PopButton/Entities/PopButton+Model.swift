//
//  PopButton+Model.swift
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

public extension PopButton {

    struct Model {
        /// Direction of the edges of the button
        public var direction: EdgeDirection = .bottomRight

        /// Position of the button w.r.t the super ``PopView``.
        public var position: PopButton.Position

        /// Button color
        public var backgroundColor: UIColor

        /// color of the pop container color.
        /// bg color of the ``PopView`` which is the super view of the button
        public var superViewColor: UIColor?

        /// bg color of the container( bg color of container view which is the super view of the ``PopView`` which is holding the ``PopButton`` )
        /// this will be necessary to draw the edges of the button in some positions.
        public var parentContainerBGColor: UIColor?

        /// border colors of button's content face.
        public var buttonFaceBorderColor: EdgeColors?

        /// border colors of the edges of the button.
        public var borderColors: PopButton.BorderModel?

        /// width of the border.
        public var borderWidth: CGFloat = 0.0

        /// presence of the other button close the edges the current button.
        public var adjacentButtonAvailability: AdjacentButtonAvailability?

        /// customise the color of the edges.
        public var customEdgeColor: EdgeColors?

        /// depth of the edges.
        public var edgeLength: CGFloat = 0.0

        /// It is used to add static borders which doesn't move with press effect of the ``PopButton``
        public var showStaticBaseEdges: Bool = false

        /// appearance model for shimmer
        public var shimmerStyle: ShimmerStyle?

        public init(direction: EdgeDirection = .bottomRight,
                    position: PopButton.Position,
                    backgroundColor: UIColor,
                    superViewColor: UIColor? = nil,
                    parentContainerBGColor: UIColor? = nil,
                    buttonFaceBorderColor: EdgeColors? = nil,
                    borderColors: PopButton.BorderModel? = nil,
                    borderWidth: CGFloat = 0.0,
                    edgeLength: CGFloat = 3,
                    adjacentButtonAvailability: AdjacentButtonAvailability? = nil,
                    customEdgeColor: EdgeColors? = nil,
                    showStaticBaseEdges: Bool = false,
                    shimmerStyle: ShimmerStyle? = nil) {
            self.direction = direction
            self.position = position
            self.backgroundColor = backgroundColor
            self.superViewColor = superViewColor
            self.parentContainerBGColor = parentContainerBGColor
            self.buttonFaceBorderColor = buttonFaceBorderColor
            self.borderColors = borderColors
            self.borderWidth = borderWidth
            self.adjacentButtonAvailability = adjacentButtonAvailability
            self.customEdgeColor = customEdgeColor
            self.edgeLength = edgeLength
            self.showStaticBaseEdges = showStaticBaseEdges
            self.shimmerStyle = shimmerStyle
        }
    }

}
