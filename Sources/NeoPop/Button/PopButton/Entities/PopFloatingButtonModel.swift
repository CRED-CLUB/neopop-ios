//
//  PopFloatingButtonModel.swift
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

        public let buttonColor: UIColor
        public let shadowColor: UIColor
        public let edgeWidth: CGFloat
        public let customEdgeColor: UIColor?
        public let borderColor: UIColor?
        public let borderWidth: CGFloat
        public var shimmerModel: PopShimmerModel?
        public let disabledButtonColor: UIColor

        public init(buttonColor: UIColor = UIColor.white,
                    shadowColor: UIColor = UIColor.black,
                    edgeWidth: CGFloat = 10,
                    customEdgeColor: UIColor? = nil,
                    borderColor: UIColor? = nil,
                    borderWidth: CGFloat = 0,
                    shimmerModel: PopShimmerModel? = nil,
                    disabledButtonColor: UIColor = UIColor.white.withAlphaComponent(0.3)) {
            self.buttonColor = buttonColor
            self.customEdgeColor = customEdgeColor
            self.shadowColor = shadowColor
            self.edgeWidth = edgeWidth
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.shimmerModel = shimmerModel
            self.disabledButtonColor = disabledButtonColor
        }
    }
}
