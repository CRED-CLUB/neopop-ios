//
//  PopSelectionControl+Model.swift
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

public extension PopSelectionControl {

    /// This model is used to configure the appearance of the model for `selected` and `unselected` state
    /// for ``PopRadioButton`` and ``PopCheckBox``
    struct Model {
        /// used to configure the border color of the control
        let borderColor: UIColor

        /// used to configure the background color of the control
        let backgroundColor: UIColor

        /// used to configure the image for a given state
        let image: UIImage?

        public init(borderColor: UIColor, backgroundColor: UIColor, image: UIImage?) {
            self.borderColor = borderColor
            self.backgroundColor = backgroundColor
            self.image = image
        }
    }

}
