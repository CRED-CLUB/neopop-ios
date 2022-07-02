//
//  PopShimmerLayer.swift
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

final class PopShimmerLayer: CALayer {
    private lazy var shimmerLayer = CAShapeLayer()
    private var isShimmerEnabled: Bool = false
    private var shimmerRepeatCount: Float = .infinity
    private var shimmerStyle: ShimmerStyle?

    override var bounds: CGRect {
        didSet {
            guard bounds != oldValue,
                  isShimmerEnabled else {
                return
            }

            beginShimmerAnimation(withStyle: shimmerStyle, repeatCount: shimmerRepeatCount)
        }
    }

    func beginShimmerAnimation(withStyle style: ShimmerStyle?, repeatCount: Float) {
        guard !(shimmerStyle == style && shimmerRepeatCount == repeatCount) ||
                !isShimmerEnabled else {
            return
        }

        shimmerStyle = style
        shimmerRepeatCount = repeatCount
        self.isShimmerEnabled = true

        shimmerLayer.isHidden = false
        shimmerLayer.removeAllAnimations()
        _beginShimmerAnimation(withStyle: style, repeatCount: repeatCount)
    }

    func endShimmerAnimation() {
        guard isShimmerEnabled else {
            return
        }

        isShimmerEnabled = false
        shimmerLayer.removeAllAnimations()
        shimmerLayer.isHidden = true
    }
}

private extension PopShimmerLayer {
    func _beginShimmerAnimation(withStyle style: ShimmerStyle?, repeatCount: Float) {
        switch style {
        case .single(let angle, let width, let color, let duration, let delay):
            startSingleShimmer(lineWidth: width, angle: angle, color: color, duration: duration, repeatCount: repeatCount, delay: delay)
        case .double(let angle, let width1, let width2, let spacing, let color, let duration, let delay):
            startDoubleShimmer(lineWidth1: width1, lineWidth2: width2, angle: angle, spacing: spacing, color: color, duration: duration, repeatCount: repeatCount, delay: delay)
        default:
            break
        }
    }

    func startSingleShimmer(lineWidth: CGFloat = 20.0,
                            angle: CGFloat = 80.0,
                            color: UIColor,
                            duration: CFTimeInterval,
                            repeatCount: Float,
                            delay: CGFloat) {
        let inclinedSpacing: CGFloat = frame.height / tan(angle * .pi / 180) // Calculating the inclination of the shimmer layer
        let initialPath = getSingleStrip(lineWidth: lineWidth, angle: angle) // Starting path of animation (Shape on the left side)
        let finalPath = getSingleStrip(lineWidth: lineWidth, angle: angle, startX: frame.width + inclinedSpacing + lineWidth) // Final path of animation (Shape on the right side)

        if shimmerLayer.superlayer == nil {
            addSublayer(shimmerLayer)
        }

        shimmerLayer.frame = bounds
        shimmerLayer.path = initialPath.cgPath
        shimmerLayer.fillColor = color.cgColor

        // Animation layer for start path to end path
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = initialPath.cgPath
        pathAnimation.toValue = finalPath.cgPath
        pathAnimation.duration = CFTimeInterval(duration)
        pathAnimation.isRemovedOnCompletion = false

        let group = CAAnimationGroup()
        group.animations = [pathAnimation]
        group.duration = CFTimeInterval(duration + delay)
        group.repeatCount = repeatCount

        group.isRemovedOnCompletion = false

        masksToBounds = true
        shimmerLayer.add(group, forKey: "single-shimmer-path")
    }

    func startDoubleShimmer(lineWidth1: CGFloat = 10.0, lineWidth2: CGFloat = 30.0, angle: CGFloat = 80.0, spacing: CGFloat = 20.0, color: UIColor, duration: CFTimeInterval, repeatCount: Float, delay: CGFloat) {

        let inclinedSpacing: CGFloat = frame.height / tan(angle * .pi / 180)

        let leftFirstInclinedShape = getSingleStrip(lineWidth: lineWidth1, angle: angle)
        let leftSecondInclinedShape = getSingleStrip(lineWidth: lineWidth2, angle: angle, startX: spacing + lineWidth2)

        let initialPath = leftSecondInclinedShape
        initialPath.append(leftFirstInclinedShape)

        if shimmerLayer.superlayer == nil {
            addSublayer(shimmerLayer)
        }
        shimmerLayer.frame = bounds
        shimmerLayer.path = initialPath.cgPath
        shimmerLayer.fillColor = color.cgColor

        // translation.x for shimmer
        let translationAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        translationAnimation.fromValue = -spacing - lineWidth2
        translationAnimation.toValue = frame.width + lineWidth1 + lineWidth2 + inclinedSpacing + spacing
        translationAnimation.duration = CFTimeInterval(duration)
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false

        let group = CAAnimationGroup()
        group.animations = [translationAnimation]
        group.duration = CFTimeInterval(duration + delay)
        group.repeatCount = repeatCount
        group.isRemovedOnCompletion = false
        shimmerLayer.add(group, forKey: "double-shimmer-translation")

        masksToBounds = true
    }

    func getSingleStrip(lineWidth: CGFloat, angle: CGFloat, startX: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let inclinedSpacing: CGFloat = frame.height / tan(angle * .pi / 180)
        let point1 = CGPoint(x: startX-inclinedSpacing, y: frame.height)
        let point2 = CGPoint(x: startX-inclinedSpacing - lineWidth, y: frame.height)
        let point3 = CGPoint(x: startX-lineWidth, y: 0)
        let point4 = CGPoint(x: startX, y: 0)
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.close()
        return path
    }
}
