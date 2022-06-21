//
//  PopConfiguration.swift
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

/// It is configuration model used to modify the different properties of ``PopButton`` and ``PopFloatingButton``
public struct PopConfiguration {

    /// It contains all globally configurable properties related to ``PopButton``
    public struct PopButton {
        /// It controls the press animation duration of ``PopButton``
        public static var pressDuration: TimeInterval = 0.15
    }

    /// It contains all globally configurable properties related to ``PopFloatingButton``
    public struct PopFloatingButton {
        /// It controls the press animation duration of floating button
        public static var touchDownDuration: TimeInterval = 0.2

        /// It controls the press release animation duration of floating button
        public static var touchUpDuration: TimeInterval = 0.5

        /// It controls the levitating animation duration of floating button
        public static var levitatingAnimationDuration: TimeInterval = 2.0
    }
}
