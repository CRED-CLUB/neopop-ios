//
//  PopFloatingButton+Model.swift
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

import Foundation
import UIKit

public extension PopFloatingButton {
    struct Model {

        /// background color of the floating ``PopView``
        public let backgroundColor: UIColor

        /// color of the shadow below the floating ``PopView``
        public let shadowColor: UIColor

        /// depth of the edges.
        public let edgeWidth: CGFloat

        /// Color of the horizontal edge in the view. Optional input as it will be derived from bg color
        public let customEdgeColor: UIColor?

        /// Color of the content edge borders. customizable for each side of the edge
        public let borderColor: UIColor?

        /// width for the border
        public let borderWidth: CGFloat

        /// appearance model for shimmer
        public var shimmerModel: PopShimmerModel?

        /// color of the button background when it is disabled
        public let disabledBackgroundColor: UIColor

        public init(backgroundColor: UIColor = UIColor.white,
                    shadowColor: UIColor = UIColor.black,
                    edgeWidth: CGFloat = 10,
                    customEdgeColor: UIColor? = nil,
                    borderColor: UIColor? = nil,
                    borderWidth: CGFloat = 0,
                    shimmerModel: PopShimmerModel? = nil,
                    disabledBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.3)) {
            self.backgroundColor = backgroundColor
            self.customEdgeColor = customEdgeColor
            self.shadowColor = shadowColor
            self.edgeWidth = edgeWidth
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.shimmerModel = shimmerModel
            self.disabledBackgroundColor = disabledBackgroundColor
        }
    }
}
