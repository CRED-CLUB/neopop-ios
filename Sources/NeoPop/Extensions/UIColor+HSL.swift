//
//  UIColor+HSL.swift
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

extension UIColor {
    var luminaceValue: CGFloat {
        let coreColour = CIColor(color: self)
        var red = coreColour.red
        var green = coreColour.green
        var blue = coreColour.blue

        // 1a - Clamp these colours between 0 and 1 (combat sRGB colour space)
        red = red.clamp(min: 0, max: 1)
        green = green.clamp(min: 0, max: 1)
        blue = blue.clamp(min: 0, max: 1)

        // 2 - Find the minimum and maximum values of R, G and B.
        guard let minRGB = [red, green, blue].min(), let maxRGB = [red, green, blue].max() else {
            return 0.0
        }

        // 3 - Now calculate the Luminace value by adding the max and min values and divide by 2.
        let luminosity = (minRGB + maxRGB) / 2

        return luminosity
    }
}

// Fantastic explanation of how it works
// http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
fileprivate extension CGFloat {
    /// clamp the supplied value between a min and max
    /// - Parameter min: The min value
    /// - Parameter max: The max value
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if self < min {
            return min
        } else if self > max {
            return max
        } else {
            return self
        }
    }

    /// If colour value is less than 1, add 1 to it. If temp colour value is greater than 1, substract 1 from it
    func convertToColourChannel() -> CGFloat {
        let min: CGFloat = 0
        let max: CGFloat = 1
        let modifier: CGFloat = 1
        if self < min {
            return self + modifier
        } else if self > max {
            return self - max
        } else {
            return self
        }
    }

    /// Formula to convert the calculated colour from colour multipliers
    /// - Parameter temp1: Temp variable one (calculated from luminosity)
    /// - Parameter temp2: Temp variable two (calcualted from temp1 and luminosity)
    func convertToRGB(temp1: CGFloat, temp2: CGFloat) -> CGFloat {
        if 6 * self < 1 {
            return temp2 + (temp1 - temp2) * 6 * self
        } else if 2 * self < 1 {
            return temp1
        } else if 3 * self < 2 {
            return temp2 + (temp1 - temp2) * (0.666 - self) * 6
        } else {
            return temp2
        }
    }
}
