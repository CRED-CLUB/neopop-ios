//
//  PopButton+State.swift
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

public extension PopButton {

    /*
     * This state is change between,
     * 1. normal - normal state. //user interaction enabeld
     * 2. pressed - when user presses it. // user interaction enabeld.
     * 2. loading - loading state //user inteaction will be disabled
     * 3. success - success animation state //user inteaction will be disabled
     */
    enum State: Equatable {
        case normal
        case pressed
        case loading
        case success
        case disabled(withOpacity: Bool)
        case unknown

        public var isHighLighted: Bool {
            switch self {
            case .pressed:
                return true
            default:
                return false
            }
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {

            switch (lhs, rhs) {
            case (.normal, .normal), (.pressed, .pressed), (.loading, .loading), (.success, .success), (.unknown, .unknown) :
                return true

            case (.disabled(let withOpacityLHS), .disabled(let withOpacityRHS)):
                return withOpacityLHS == withOpacityRHS

            default:
                return false
            }

        }
    }

}
