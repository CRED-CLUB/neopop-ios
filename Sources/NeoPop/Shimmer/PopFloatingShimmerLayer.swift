//
//  PopFloatingShimmerLayer.swift
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

final class PopFloatingShimmerLayer: CAShapeLayer {
    struct SizeModel: Equatable {
        let inclination: CGFloat
        let edgeOffset: CGFloat
    }

    private lazy var topShapeLayer = CAShapeLayer()
    private lazy var bottomShapeLayer = CAShapeLayer()
    private lazy var bottomMaskLayer = CAShapeLayer()

    private lazy var baseMask = CAShapeLayer()

    private var shimmerModel: PopShimmerModel?
    private var sizeModel: SizeModel?
    private var shimmerRepeatCount: Float = .infinity
    private var isShimmerEnabled: Bool = false

    private let animationKey = "path"

    override var bounds: CGRect {
        didSet {
            guard bounds != oldValue,
                  isShimmerEnabled else { return }
            _setShimmerAnimation(model: shimmerModel, sizeModel: sizeModel, shimmerRepeatCount: shimmerRepeatCount)
        }
    }
}

extension PopFloatingShimmerLayer {
    func beginShimmerAnimation(model: PopShimmerModel?,
                               sizeModel: SizeModel?,
                               shimmerRepeatCount: Float) {
        // if there is no change in data, there is no need to restart the animation,
        // so we can leave the existing animation to continue
        guard !(self.shimmerModel == model && self.sizeModel == sizeModel && shimmerRepeatCount == self.shimmerRepeatCount) || !isShimmerEnabled else {
            return
        }

        self.shimmerModel = model
        self.sizeModel = sizeModel
        self.shimmerRepeatCount = shimmerRepeatCount

        _setShimmerAnimation(model: model, sizeModel: sizeModel, shimmerRepeatCount: shimmerRepeatCount)
    }

    func endShimmerAnimation() {
        guard isShimmerEnabled else { return }
        isShimmerEnabled = false
        topShapeLayer.removeAnimation(forKey: animationKey)
        bottomShapeLayer.removeAnimation(forKey: animationKey)
        isHidden = true
    }
}

// MARK: Private Methods
private extension PopFloatingShimmerLayer {
    func _setShimmerAnimation(model: PopShimmerModel?,
                              sizeModel: SizeModel?,
                              shimmerRepeatCount: Float) {
        guard let model = model,
              let sizeModel = sizeModel else { return }

        isShimmerEnabled = true
        topShapeLayer.removeAnimation(forKey: animationKey)
        bottomShapeLayer.removeAnimation(forKey: animationKey)
        isHidden = false

        let leftFirstStripFrameRect = getFirstFrameRect(lineWidth: model.lineWidth1, sizeModel: sizeModel)
        let path = leftFirstStripFrameRect
        if let lineWidth2 = model.lineWidth2 {
            let leftSecondStripFrameRect = getFirstFrameRect(lineWidth: lineWidth2, startX: model.lineWidth1 + model.spacing, sizeModel: sizeModel)
            path.append(leftSecondStripFrameRect)
        }

        if topShapeLayer.superlayer == nil {
            addSublayer(topShapeLayer)
        }

        topShapeLayer.frame = bounds
        topShapeLayer.path = path.cgPath
        topShapeLayer.fillColor = model.lineColor1.withAlphaComponent(model.lineBottomAlpha).cgColor
        topShapeLayer.transform = CATransform3DMakeTranslation(-model.lineWidth1, 0, 0)

        if bottomShapeLayer.superlayer == nil {
            addSublayer(bottomShapeLayer)
            bottomShapeLayer.mask = bottomMaskLayer
        }

        bottomShapeLayer.path = path.cgPath
        bottomShapeLayer.fillColor = model.lineColor1.cgColor
        bottomShapeLayer.frame = bounds
        bottomShapeLayer.transform = topShapeLayer.transform

        bottomMaskLayer.path = getBottomShapeMaskRect(edgeOffset: sizeModel.edgeOffset)

        baseMask.path = getShimmerMaskRect(sizeModel: sizeModel)
        mask = baseMask

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = topShapeLayer.path

        let rightFirstStripFrameRect = getLastRect(lineWidth: model.lineWidth1, sizeModel: sizeModel)
        let path2 = rightFirstStripFrameRect
        if let lineWidth2 = model.lineWidth2 {
            let rightLastStripFrameRect = getLastRect(lineWidth: lineWidth2, startX: model.lineWidth1 + model.spacing, sizeModel: sizeModel)
            path2.append(rightLastStripFrameRect)
        }
        pathAnimation.toValue = path2.cgPath
        pathAnimation.duration = CFTimeInterval(model.duration)

        let moveAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        moveAnimation.fromValue = -model.lineWidth1 - model.spacing - (model.lineWidth2 ?? 0.0)
        moveAnimation.toValue = bounds.width - model.lineWidth1
        pathAnimation.duration = CFTimeInterval(model.duration)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [pathAnimation, moveAnimation]
        groupAnimation.duration = CFTimeInterval(model.duration)
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards

        let delayGroupAnimation = CAAnimationGroup()
        delayGroupAnimation.animations = [groupAnimation]
        delayGroupAnimation.duration = CFTimeInterval(model.duration + model.delay)
        delayGroupAnimation.isRemovedOnCompletion = false
        delayGroupAnimation.repeatCount = shimmerRepeatCount

        topShapeLayer.add(delayGroupAnimation, forKey: animationKey)
        bottomShapeLayer.add(delayGroupAnimation, forKey: animationKey)
    }

    // MARK: Bezierpath Utility Methods
    func getShimmerMaskRect(sizeModel: SizeModel) -> CGPath {
        let offSet = sizeModel.edgeOffset
        let offSetWidth = bounds.width - offSet
        let offSetHeight = bounds.height - offSet
        let inclinationOffSet = offSet * sizeModel.inclination
        let maxHeight: CGFloat = bounds.height

        let point1 = CGPoint(x: inclinationOffSet, y: 0)
        let point2 = CGPoint(x: 0, y: offSetHeight)
        let point3 = CGPoint(x: offSet/2, y: maxHeight)
        let point4 = CGPoint(x: offSetWidth + offSet/2, y: maxHeight)
        let point5 = CGPoint(x: bounds.width, y: offSetHeight)
        let point6 = CGPoint(x: bounds.width - inclinationOffSet, y: 0)

        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.close()
        return path.cgPath
    }

    func getBottomShapeMaskRect(edgeOffset: CGFloat) -> CGPath {
        let offSetHeight = bounds.height - edgeOffset

        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 0, y: offSetHeight)
        let point5 = CGPoint(x: bounds.width, y: offSetHeight)
        let point6 = CGPoint(x: bounds.width, y: 0)

        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point5)
        path.addLine(to: point6)

        path.close()
        return path.cgPath
    }

    func getFirstFrameRect(lineWidth: CGFloat,
                           startX: CGFloat = 0,
                           sizeModel: SizeModel) -> UIBezierPath {
        let offSetHeight = bounds.height - sizeModel.edgeOffset
        let inclinationOffSet = sizeModel.edgeOffset * sizeModel.inclination
        let maxHeight: CGFloat = bounds.height

        let point1 = CGPoint(x: startX + inclinationOffSet, y: 0)
        let point2 = CGPoint(x: startX + inclinationOffSet + lineWidth, y: 0)
        let point3 = CGPoint(x: startX + lineWidth, y: offSetHeight)
        let point4 = CGPoint(x: startX + sizeModel.edgeOffset/2 + lineWidth, y: maxHeight)
        let point5 = CGPoint(x: startX + sizeModel.edgeOffset/2, y: maxHeight)
        let point6 = CGPoint(x: startX, y: offSetHeight)

        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.close()
        return path
    }

    func getLastRect(lineWidth: CGFloat,
                     startX: CGFloat = 0,
                     sizeModel: SizeModel) -> UIBezierPath {
        let offSetHeight = bounds.height - sizeModel.edgeOffset
        let inclinationOffSet = sizeModel.edgeOffset * sizeModel.inclination
        let maxHeight: CGFloat = bounds.height

        let point1 = CGPoint(x: startX, y: 0)
        let point2 = CGPoint(x: startX + lineWidth, y: 0)
        let point3 = CGPoint(x: startX + lineWidth + inclinationOffSet, y: offSetHeight)
        let point4 = CGPoint(x: point3.x - sizeModel.edgeOffset/2, y: maxHeight)
        let point5 = CGPoint(x: point3.x - sizeModel.edgeOffset/2 - lineWidth, y: maxHeight)
        let point6 = CGPoint(x: startX + inclinationOffSet, y: offSetHeight)

        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.close()
        return path
    }
}
