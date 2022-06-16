//
//  PopButton+Properties.swift
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

extension PopButton {
    var normalStateEdgeDirection: EdgeDirection {
        model.direction
    }

    var neoButtonBackgroundColor: UIColor {
        model.backgroundColor
    }

    var neoButtonBorderColor: PopButton.BorderModel? {
        model.borderColors
    }

    var customEdgeColor: EdgeColors? {
        model.customEdgeColor
    }

    var buttonFaceBorderColor: EdgeColors? {
        model.buttonFaceBorderColor
    }

    var parentBGColor: UIColor {
        model.parentContainerBGColor ?? .clear
    }

    var edgePadding: CGFloat {
        model.edgeLength
    }
}
