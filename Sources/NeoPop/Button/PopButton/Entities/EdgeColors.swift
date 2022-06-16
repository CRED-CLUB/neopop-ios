//
//  EdgeColors.swift
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

///
/// Provide custom colors to all side borders of the edges.
///
public struct EdgeColors: Equatable {
    public var left: UIColor?
    public var right: UIColor?
    public var bottom: UIColor?
    public var top: UIColor?

    public init(color: UIColor?) {
        left = color
        right = color
        bottom = color
        top = color
    }

    public init(left: UIColor?, right: UIColor?, top: UIColor?, bottom: UIColor?) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}
