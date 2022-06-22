//
//  CALayer+Shimmer.swift
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

public extension CALayer {
    private static let shimmerLayerName = "ContentShimmerLayer"

    /// It adds and starts a shimmer animation on any CALayer
    ///
    /// First it creates a shimmer layer if there is none and begins the shimmer animation
    /// Also it internally manages the shimmer layer lifecycle when calling ``startShimmerAnimation`` or ``removeShimmerAnimation``
    ///
    /// - To configure a double strip shimmer
    ///
    /// ```swift
    /// someLayer.startShimmerAnimation(
    ///     type: .double(angle: 70, width1: 70, width2: 50, spacing: 15, color: UIColor.white, duration: 2, delay: 2),
    ///     repeatCount: .infinity,
    ///     addOnRoot: true
    /// )
    /// ```
    ///
    /// - To configure a single strip shimmer
    ///
    /// ```swift
    /// someLayer.startShimmerAnimation(
    ///     type: .single(angle: 70, width: 50, color: UIColor.white, duration: 2, delay: 2),
    ///     repeatCount: .infinity,
    ///     addOnRoot: true
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - type: type of shimmer we want to add on the layer
    ///   - repeatCount: number of times it should repeat. to repeat endlessly use ``Float/infinity``
    ///   - addOnRoot: to add the shimmer layer as the root layer or add on top of the given layer.
    ///
    func startShimmerAnimation(type: ShimmerStyle?, repeatCount: Float, addOnRoot: Bool = false) {
        let shimmerLayer: PopShimmerLayer

        if let _shimmerLayer = sublayers?.first(where: {$0.name == Self.shimmerLayerName}) as? PopShimmerLayer {
            shimmerLayer = _shimmerLayer
        } else {
            shimmerLayer = PopShimmerLayer()
            shimmerLayer.name = Self.shimmerLayerName
        }

        if addOnRoot {
            insertSublayer(shimmerLayer, at: 0)
        } else {
            addSublayer(shimmerLayer)
        }
        shimmerLayer.frame = bounds
        shimmerLayer.beginShimmerAnimation(withStyle: type, repeatCount: repeatCount)
    }

    /// It removes the existing shimmer animation if it is active
    ///
    /// Note: It doesn't remove the shimmer layer. But keeps it inactive
    func removeShimmerAnimation() {
        let shimmerLayer = sublayers?.first(where: {$0.name == Self.shimmerLayerName}) as? PopShimmerLayer
        shimmerLayer?.endShimmerAnimation()
    }
}
