//
//  PopSwitch+Model.swift
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

public extension PopSwitch {
    struct Model {
        /// border color of the switch
        let borderColor: UIColor
        
        /// background color of the switch
        let backgroundColor: UIColor
        
        /// fill color of the thumb outer boundary
        let thumbBoundaryColor: UIColor
        
        /// fill color of the thumb inner boundary
        let thumbCenterColor: UIColor
        
        public init(borderColor: UIColor, backgroundColor: UIColor, thumbBoundaryColor: UIColor, thumbCenterColor: UIColor) {
            self.borderColor = borderColor
            self.backgroundColor = backgroundColor
            self.thumbBoundaryColor = thumbBoundaryColor
            self.thumbCenterColor = thumbCenterColor
        }
    }
}
