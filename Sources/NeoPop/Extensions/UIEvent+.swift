//
//  UIEvent+.swift
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

public extension UITouch {

    func toControlEvent() -> UIControl.Event? {
        guard let view = self.view else {
            return nil
        }
        let isInside = view.bounds.contains(self.location(in: view))
        let wasInside = view.bounds.contains(self.previousLocation(in: view))
        switch self.phase {
        case .began:
            if isInside {
                if self.tapCount > 1 {
                    return .touchDownRepeat
                }
                return .touchDown
            }
            return nil
        case .moved:
            if isInside && wasInside {
                return .touchDragInside
            } else if isInside && !wasInside {
                return .touchDragEnter
            } else if !isInside && wasInside {
                return .touchDragExit
            } else if !isInside && !wasInside {
                return .touchDragOutside
            } else {
                return nil
            }
        case .ended:
            if isInside {
                return .touchUpInside
            } else {
                return.touchUpOutside
            }
        case .cancelled:
            return .touchCancel
        default:
            return nil
        }
    }

}

public extension UIEvent {

    func firstTouchToControlEvent() -> UIControl.Event? {
        guard let touch = self.allTouches?.first else {
            print("firstTouchToControlEvent() Error: couldn't get the first touch. \(self)")
            return nil
        }
        return touch.toControlEvent()
    }

}
