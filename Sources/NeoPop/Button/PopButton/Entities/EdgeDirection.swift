//
//  EdgeDirection.swift
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

import QuartzCore

/// This model is used to define the direction of plunk in the ``PopButton`` and ``PopView``
public enum EdgeDirection: Equatable {
    case top(customInclination: CGFloat?)
    case bottom(customInclination: CGFloat?)
    case left(customInclination: CGFloat?)
    case right(customInclination: CGFloat?)

    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    public var selectedDirection: EdgeDirection {
        switch self {
        case .top(let customInclination):
            return .bottom(customInclination: customInclination)
        case .bottom(let customInclination):
            return .top(customInclination: customInclination)
        case .left(let customInclination):
            return .right(customInclination: customInclination)
        case .right(let customInclination):
            return .left(customInclination: customInclination)
        case .topLeft:
            return .bottomRight
        case .bottomRight:
            return .topLeft
        case .topRight:
            return .bottomLeft
        case .bottomLeft:
            return .topRight
        }
    }

    public var name: String {
        switch self {
        case .top(let customInclination):
            return (customInclination ?? 1) == 0 ? "Top-flat" : "Top"
        case .bottom(let customInclination):
            return (customInclination ?? 1) == 0 ? "Bottom-flat" : "Bottom"
        case .left(let customInclination):
            return (customInclination ?? 1) == 0 ? "Left-flat" : "Left"
        case .right(let customInclination):
            return (customInclination ?? 1) == 0 ? "Right-flat" : "Right"
        case .topLeft:
            return "TopLeft"
        case .bottomRight:
            return "BottomRight"
        case .topRight:
            return "TopRight"
        case .bottomLeft:
            return "BottomLeft"
        }
    }

    func drawingManager() -> PopButtonDrawable.Type {
        switch self {
        case .bottomRight:
            return BottomRightButtonDrawManager.self
        case .bottomLeft:
            return BottomLeftButtonDrawManager.self
        case .topRight:
            return TopRightButtonDrawManager.self
        case .topLeft:
            return TopLeftButtonDrawManager.self
        case .bottom:
            return BottomEdgeButtonDrawManager.self
        case .top:
            return TopEdgeButtonDrawManager.self
        case .right:
            return RightEdgeButtonDrawManager.self
        case .left:
            return LeftEdgeButtonDrawManager.self
        }
    }

    var customInclination: CGFloat {
        switch self {
        case .top(let customInclination), .bottom(let customInclination), .left(let customInclination), .right(let customInclination):
            return customInclination ?? 1
        case .topLeft, .bottomRight, .topRight, .bottomLeft:
            return 1
        }
    }
}
