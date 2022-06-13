//
//  UIView+Constraints.swift
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

public typealias EdgeConstraints = (leading: NSLayoutConstraint, trailing: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint)

public protocol Constrainable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public extension Constrainable {
    @discardableResult
    func fill(in view: Constrainable) -> EdgeConstraints {

        if let _self = self as? UIView {
            _self.translatesAutoresizingMaskIntoConstraints = false
        }

        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = topAnchor.constraint(equalTo: view.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([leading, trailing, top, bottom])

        return (leading, trailing, top, bottom)
    }
}

public extension Constrainable where Self: UIView {
    @discardableResult
    func fillSuperview() -> EdgeConstraints {
        translatesAutoresizingMaskIntoConstraints = false

        guard let superview = superview else {
            fatalError("superview cannot be nil while adding constraints")
        }

        return fill(in: superview)
    }
}

extension UIView: Constrainable {}
extension UILayoutGuide: Constrainable {}
