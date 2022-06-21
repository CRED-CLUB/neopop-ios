//
//  PopButtonCustomContainerDrawable.swift
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

/// Use this protocol to write custom content view that
/// can be injected in both ``PopButton`` and ``PopFloatingButton``
public protocol PopButtonCustomContainerDrawable: UIView {
    
    /// This method is called whenever there is change in state of the button.
    /// - Parameter state: the new state of the button
    func updateOnStateChange(state: PopButton.State)
    
}

typealias PopFloatingButtonCustomContainerDrawable = PopButtonCustomContainerDrawable
