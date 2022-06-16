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

    func removeShimmerAnimation() {
        let shimmerLayer = sublayers?.first(where: {$0.name == Self.shimmerLayerName}) as? PopShimmerLayer
        shimmerLayer?.endShimmerAnimation()
    }

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
}
