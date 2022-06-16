//
//  PopSwitch+Mode.swift
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

public extension PopSwitch {
    /// Mode defines the appearance of the switch like color and all
    ///
    /// By default ``dark`` and ``light`` has selected and unselected state defined in the model
    ///
    /// If a custom appearance is needed use ``custom(offStateModel:onStateModel:)`` to configure `selected` and `unselected` state
    enum Mode {
        case dark
        case light
        case custom(offStateModel: PopSwitch.Model, onStateModel: PopSwitch.Model)
    }
}
