//
//  EdgeVisibilityModel.swift
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

///
/// Visibility input for the edges.
///
public struct EdgeVisibilityModel: Equatable {
    var hideBottomEdge: Bool?
    var hideTopEdge: Bool?
    var hideRightEdge: Bool?
    var hideLeftEdge: Bool?
    var hideCenterPath: Bool?

    public static func createCustomEdgeModel(
        hideBottomEdge: Bool? = nil,
        hideTopEdge: Bool? = nil,
        hideRightEdge: Bool? = nil,
        hideLeftEdge: Bool? = nil,
        hideCenterPath: Bool? = nil) -> EdgeVisibilityModel {

        EdgeVisibilityModel(
            hideBottomEdge: hideBottomEdge,
            hideTopEdge: hideTopEdge,
            hideRightEdge: hideRightEdge,
            hideLeftEdge: hideLeftEdge,
            hideCenterPath: hideCenterPath)

    }
}
