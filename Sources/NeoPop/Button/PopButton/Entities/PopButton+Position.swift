//
//  PopButton+Position.swift
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

public extension PopButton {

    /// It is used to define the position of button
    enum Position: String {
        // Corners
        case bottomRight
        case bottomLeft
        case topRight
        case topLeft

        // Edges
        case bottomEdge
        case topEdge
        case leftEdge
        case rightEdge

        // center
        case center
    }

}
