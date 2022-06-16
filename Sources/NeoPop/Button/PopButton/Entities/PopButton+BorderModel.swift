//
//  PopButton+BorderModel.swift
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

    ///
    /// Control the colors of the borders of each edges.
    /// through `PopButton.BorderModel`, we can customise every border line of an edge
    ///
    struct BorderModel {
        public var leftEdgeBorder: EdgeColors?
        public var rightEdgeBorder: EdgeColors?
        public var topEdgeBorder: EdgeColors?
        public var bottomEdgeBorder: EdgeColors?

        public init(leftEdgeBorder: EdgeColors?, rightEdgeBorder: EdgeColors?, topEdgeBorder: EdgeColors?, bottomEdgeBorder: EdgeColors?) {
            self.leftEdgeBorder = leftEdgeBorder
            self.rightEdgeBorder = rightEdgeBorder
            self.topEdgeBorder = topEdgeBorder
            self.bottomEdgeBorder = bottomEdgeBorder
        }

        public init(allEdgeIn color: UIColor) {
            self.leftEdgeBorder = EdgeColors(color: color)
            self.rightEdgeBorder = EdgeColors(color: color)
            self.topEdgeBorder = EdgeColors(color: color)
            self.bottomEdgeBorder = EdgeColors(color: color)
        }
    }

}
