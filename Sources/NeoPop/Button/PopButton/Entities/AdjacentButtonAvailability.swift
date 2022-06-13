//
//  AdjacentButtonAvailability.swift
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
/// If any adjacent `PopButton` is available to any of the edge of the button. (ie. if the button shares any edge surface with other buttons)
/// (this is used to handle visibility of the present button edges inorder to show the adgacent button edge)
///
public struct AdjacentButtonAvailability {
    let top: Bool? // if any button is
    let bottom: Bool?
    let right: Bool?
    let left: Bool?

    public static func create(
        top: Bool? = nil,
        bottom: Bool? = nil,
        left: Bool? = nil,
        right: Bool? = nil) -> AdjacentButtonAvailability {
        AdjacentButtonAvailability(top: top, bottom: bottom, right: right, left: left)
    }
}
