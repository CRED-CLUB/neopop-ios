//
//  PopHelper.swift
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

public struct PopHelper {
    /// Get horizontal edge color for a defined color in button face.
    public static func horizontalEdgeColor(for color: UIColor) -> UIColor {

        let luminosity = color.luminanceValue
        guard luminosity >= 0.3 else {
            return color.lighter(by: 30) ?? color
        }

        return color.darker(by: 30) ?? color
    }

    /// Get vertical edge color for a defined color in button face.
    public static func verticalEdgeColor(for color: UIColor) -> UIColor {

        let luminosity = color.luminanceValue
        guard luminosity >= 0.3 else {
            return color.lighter(by: 10) ?? color
        }

        return color.darker(by: 10) ?? color
    }

}
