//
//  UIColor+.swift
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

public extension UIColor {
    @inline(__always) static func fromHex(_ hex: String, alpha opacity: CGFloat? = nil) -> UIColor {
        return UIColor(fromHex: hex, alpha: opacity)
    }

    @inline(__always) convenience init(fromHex hex: String, alpha opacity: CGFloat? = nil) {
        // following ARGB color hex. same as android
        let colorCode = hex.suffix(6)
        let hexint = Int(UInt32(fromHex: String(colorCode)))
        let red: CGFloat = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue: CGFloat = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha: CGFloat
        if hex.count >= 8 {
            let alphaCode = hex.suffix(8).prefix(2)
            let alphaHexInt = Int(UInt32(fromHex: String(alphaCode)))
            alpha = opacity ?? CGFloat(alphaHexInt & 0xff) / 255.0
        } else {
            alpha = opacity ?? 1.0
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let percent = percentage / 100
            return UIColor(red: min(red + percent, 1.0),
                           green: min(green + percent, 1.0),
                           blue: min(blue + percent, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension UInt32 {
    init(fromHex hex: String) {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hex)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        self = hexInt
    }
}
