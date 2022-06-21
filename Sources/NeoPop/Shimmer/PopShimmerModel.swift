//
//  PopShimmerModel.swift
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

/// This model defines the appearance of the shimmer configurable on ``PopFloatingButton``
///
/// It renders a shimmer with double strip inclined to some degree based on the ``PopFloatingButton/Model``
///
/// - Create a shimmer model
///
/// ```swift
/// let model = PopShimmerModel(
///     spacing: 9,
///     lineColor1: UIColor.white,
///     lineColor2: UIColor.white,
///     lineWidth1: 8,
///     lineWidth2: 27,
///     duration: 2
/// )
/// ```
///
/// - Set the shimmer model for floating button
///
/// ```swift
/// floatingButton.setShimmerModel(model)
/// ```
///
/// - Start the shimmer when needed
///
/// ``` swift
/// floatingButton.startShimmerAnimation()
/// ```
///
public struct PopShimmerModel: Equatable {
    /// spacing between first and second strip
    var spacing: CGFloat = 20.0
    
    /// color of the first strip
    var lineColor1: UIColor = UIColor.white
    
    /// color of the second strip
    var lineColor2: UIColor?
    
    /// alpha for the horizontal edge of the shimmer
    ///
    /// since floating button will have dark shade of ``PopFloatingButton/Model/backgroundColor`` in the horizontal edge,
    /// we would need shimmer to have same dark effect. So this property controls the dark shade of the shimmer.
    ///
    /// It is recommended not to change this property unless needed otherwise.
    var lineBottomAlpha: CGFloat = 0.4
    
    /// width of the first strip
    var lineWidth1: CGFloat = 10.0
    
    /// width of the second strip
    var lineWidth2: CGFloat?
    
    /// duration of each cycle of shimmer from start and end frame of the button
    var duration: CGFloat
    
    /// delay between each cycle
    var delay: CGFloat

    public init(spacing: CGFloat = 20.0, lineColor1: UIColor = UIColor.white, lineColor2: UIColor? = nil, lineBottomAlpha: CGFloat = 0.4, lineWidth1: CGFloat = 10.0, lineWidth2: CGFloat? = nil, duration: CGFloat, delay: CGFloat = 0) {
        self.spacing = spacing
        self.lineColor1 = lineColor1
        self.lineColor2 = lineColor2
        self.lineBottomAlpha = lineBottomAlpha
        self.lineWidth1 = lineWidth1
        self.lineWidth2 = lineWidth2
        self.duration = duration
        self.delay = delay
    }

    public static var `default`: PopShimmerModel {
        PopShimmerModel(spacing: 8, lineColor1: UIColor.white, lineColor2: UIColor.white, lineWidth1: 15, lineWidth2: 25, duration: 3)
    }
}

public enum ShimmerStyle: Equatable {
    case single(angle: CGFloat, width: CGFloat, color: UIColor, duration: CGFloat, delay: CGFloat = 0)
    case double(angle: CGFloat, width1: CGFloat, width2: CGFloat, spacing: CGFloat, color: UIColor, duration: CGFloat, delay: CGFloat =  0)
    case none
}
