//
//  PopView.swift
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

open class PopView: UIView {
    private let popContentBGLayer = PopContentLayer()
    private let verticalEdgeLayer = PopContentLayer()
    private let horizontalEdgeLayer = PopContentLayer()

    private var shimmerLayer: PopFloatingShimmerLayer?

    var viewModel: PopView.Model?

    open override var bounds: CGRect {
        didSet {
            guard bounds != oldValue else { return }
            setNeedsDisplay()
        }
    }

    public init() {
        super.init(frame: .zero)
        configureLayers()
    }

    public init(frame: CGRect, model: PopView.Model) {
        super.init(frame: frame)
        viewModel = model
        configureLayers()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayers()
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawVerticalEdge(rect)
        drawHorizontalEdge(rect)
        drawContentCenter(rect)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        configureLayerFrames(bounds)
    }
}

// MARK: Public Methods
public extension PopView {
    func configurePopView(withModel model: PopView.Model) {
        // if we receive same model again no need to redraw the pop view.
        guard self.viewModel != model else { return }

        self.viewModel = model
        self.setNeedsDisplay()
    }
}

// MARK: Shimmer Methods
extension PopView {
    func startShimmer(repeatCount: Float, shimmerModel: PopShimmerModel?) {
        guard let viewModel = viewModel,
              let shimmerModel = shimmerModel else {
            return
        }

        if shimmerLayer == nil {
            let shimmerLayer = PopFloatingShimmerLayer()
            layer.insertSublayer(shimmerLayer, above: horizontalEdgeLayer)
            self.shimmerLayer = shimmerLayer
        }

        shimmerLayer?.frame = bounds
        shimmerLayer?.beginShimmerAnimation(model: shimmerModel, sizeModel: PopFloatingShimmerLayer.SizeModel(inclination: viewModel.neoPopEdgeDirection.customInclination, edgeOffset: viewModel.edgeOffSet), shimmerRepeatCount: repeatCount)
    }

    func stopShimmer() {
        shimmerLayer?.endShimmerAnimation()
    }
}

// MARK: Setup methods
private extension PopView {
    func configureLayers() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        self.layer.insertSublayer(horizontalEdgeLayer, at: 0)
        self.layer.insertSublayer(verticalEdgeLayer, at: 0)
        self.layer.insertSublayer(popContentBGLayer, at: 0)

        popContentBGLayer.backgroundColor = UIColor.clear.cgColor
        verticalEdgeLayer.backgroundColor = UIColor.clear.cgColor
        horizontalEdgeLayer.backgroundColor = UIColor.clear.cgColor
    }

    func configureLayerFrames(_ bounds: CGRect) {
        popContentBGLayer.frame = bounds
        verticalEdgeLayer.frame = bounds
        horizontalEdgeLayer.frame = bounds
        shimmerLayer?.frame = bounds
    }

    func resetLayer(_ layer: PopContentLayer) {
        layer.path = nil
        layer.fillColor = UIColor.clear.cgColor
        layer.hideAllBorders()
    }
}

// MARK: Layer Draw Methods
private extension PopView {
    ///
    /// Draw center part of the `PopView`
    ///
    func drawContentCenter(_ bounds: CGRect) {
        guard let viewModel = viewModel,
              !(viewModel.customEdgeVisibility?.hideCenterPath ?? false) else {
            resetLayer(popContentBGLayer)
            return
        }

        var offSetWidth = bounds.width - viewModel.edgeOffSet
        var offSetHeight = bounds.height - viewModel.edgeOffSet
        let offSet = viewModel.edgeOffSet

        let edge = viewModel.neoPopEdgeDirection
        let color = viewModel.backgroundColor

        let maxWidth =  bounds.width
        let maxHeight = bounds.height

        var point1: CGPoint = CGPoint.zero
        var point2: CGPoint = CGPoint.zero
        var point3: CGPoint = CGPoint.zero
        var point4: CGPoint = CGPoint.zero
        var point5: CGPoint = CGPoint.zero

        var customBorderPoints: CustomBorderDrawingPoints = CustomBorderDrawingPoints()
        var path: UIBezierPath! = viewModel.delegate?.getPathForCenterContentLayer(view: superview, frame: bounds, model: viewModel, borderPoints: &customBorderPoints)

        if path == nil {
            path = UIBezierPath()

            // 'flatSurface' defines whether the surface is slanting on straight.
            switch edge {
            case .top(let customInclination): // TODO: needs to handle the flat top drawing

                let inclinationOffSet = (viewModel.edgeOffSet * (customInclination ?? 1))

                offSetWidth = max(bounds.width / 2, bounds.width - inclinationOffSet)

                point1 = CGPoint(x: 0, y: offSet)
                point2 = CGPoint(x: inclinationOffSet, y: maxHeight)
                point3 = CGPoint(x: offSetWidth, y: maxHeight)
                point4 = CGPoint(x: maxWidth, y: offSet)
                point5 = CGPoint(x: 0, y: offSet)

            case .bottom(let customInclination): // TODO: needs to handle the flat top drawing

                let inclinationOffSet = (viewModel.edgeOffSet * (customInclination ?? 1))

                offSetWidth = max(bounds.width / 2, bounds.width - inclinationOffSet)

                point1 = CGPoint(x: inclinationOffSet, y: 0)
                point2 = CGPoint(x: 0, y: offSetHeight)
                point3 = CGPoint(x: maxWidth, y: offSetHeight)
                point4 = CGPoint(x: offSetWidth, y: 0)
                point5 = CGPoint(x: inclinationOffSet, y: 0)

            case .left(let customInclination): // TODO: needs to handle the flat top drawing

                let inclinationOffSet = (viewModel.edgeOffSet * (customInclination ?? 1))

                offSetHeight = max(bounds.width / 2, bounds.height - inclinationOffSet)

                point1 = CGPoint(x: offSet, y: 0)
                point2 = CGPoint(x: offSet, y: maxHeight)
                point3 = CGPoint(x: maxWidth, y: offSetHeight)
                point4 = CGPoint(x: maxWidth, y: inclinationOffSet)
                point5 = CGPoint(x: offSet, y: 0)

            case .right(let customInclination): // TODO: needs to handle the flat top drawing

                let inclinationOffSet = (viewModel.edgeOffSet * (customInclination ?? 1))

                offSetHeight = max(bounds.width / 2, bounds.height - inclinationOffSet)

                point1 = CGPoint(x: 0, y: inclinationOffSet)
                point2 = CGPoint(x: 0, y: offSetHeight)
                point3 = CGPoint(x: offSetWidth, y: maxHeight)
                point4 = CGPoint(x: offSetWidth, y: 0)
                point5 = CGPoint(x: 0, y: inclinationOffSet)

            // Inclined
            case .bottomRight:
                point1 = CGPoint(x: 0, y: 0)
                point2 = CGPoint(x: 0, y: offSetHeight)
                point3 = CGPoint(x: offSetWidth, y: offSetHeight)
                point4 = CGPoint(x: offSetWidth, y: 0)
                point5 = CGPoint(x: 0, y: 0)

            case .bottomLeft:
                point1 = CGPoint(x: offSet, y: 0)
                point2 = CGPoint(x: offSet, y: offSetHeight)
                point3 = CGPoint(x: maxWidth, y: offSetHeight)
                point4 = CGPoint(x: maxWidth, y: 0)
                point5 = CGPoint(x: offSet, y: 0)

            case .topRight:
                point1 = CGPoint(x: 0, y: offSet)
                point2 = CGPoint(x: 0, y: maxHeight)
                point3 = CGPoint(x: offSetWidth, y: maxHeight)
                point4 = CGPoint(x: offSetWidth, y: offSet)
                point5 = CGPoint(x: 0, y: offSet)

            case .topLeft:
                point1 = CGPoint(x: offSet, y: offSet)
                point2 = CGPoint(x: offSet, y: maxHeight)
                point3 = CGPoint(x: maxWidth, y: maxHeight)
                point4 = CGPoint(x: maxWidth, y: offSet)
                point5 = CGPoint(x: offSet, y: offSet)
            }

            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)
            path.addLine(to: point4)
            path.addLine(to: point5)

        } else {
            point1 = customBorderPoints.point1
            point2 = customBorderPoints.point2
            point3 = customBorderPoints.point3
            point4 = customBorderPoints.point4
            point5 = customBorderPoints.point5
        }

        path.close()

        let borderWidth = viewModel.borderWidth

        drawBorders(points: (point1, point2, point3, point4, point5),
                    colors: viewModel.centerBorderColors,
                    borderWidth: borderWidth,
                    position: .center,
                    drawBorder: true,
                    layer: popContentBGLayer)

        popContentBGLayer.path = path.cgPath
        popContentBGLayer.lineWidth = 0
        popContentBGLayer.fillColor = color.cgColor
    }

    ///
    /// Draw vertical edge of the `PopView`
    ///
    func drawVerticalEdge(_ bounds: CGRect) {
        resetLayer(verticalEdgeLayer)

        guard let viewModel = viewModel else {
            return
        }

        // let bounds = verticalEdgeLayer.bounds
        let offSetWidth = bounds.width - viewModel.edgeOffSet
        let offSetHeight = bounds.height - viewModel.edgeOffSet
        let offSet = viewModel.edgeOffSet

        let edge = viewModel.neoPopEdgeDirection
        let color = viewModel.verticalEdgeColor

        var clippedOriginY: CGFloat = 0.0
        let maxWidth: CGFloat = bounds.width
        var maxHeight: CGFloat = bounds.height

        switch viewModel.clipsToOffSetHeight {
        case .none:
            break
        case .clipDistantCorners: // default case

            switch edge {
            case .topRight, .topLeft:
                clippedOriginY = 0
                maxHeight = offSetHeight
            case .bottomRight, .bottomLeft:
                clippedOriginY = offSet
                maxHeight = bounds.height
            default:
                clippedOriginY = 0
                maxHeight = offSetHeight
            }

        case .clipJoinedCorners: // special case
            switch edge {
            case .topRight, .topLeft:
                clippedOriginY = offSet
                maxHeight = bounds.height

            case .bottomRight, .bottomLeft:
                clippedOriginY = 0
                maxHeight = offSetHeight

            default:
                clippedOriginY = offSet
                maxHeight = bounds.height
            }

        }

        var point1: CGPoint = CGPoint.zero
        var point2: CGPoint = CGPoint.zero
        var point3: CGPoint = CGPoint.zero
        var point4: CGPoint = CGPoint.zero
        var point5: CGPoint = CGPoint.zero

        var customBorderPoints: CustomBorderDrawingPoints = CustomBorderDrawingPoints()
        var path: UIBezierPath! = viewModel.delegate?.getPathForVerticalLayer(view: superview, frame: bounds, model: viewModel, borderPoints: &customBorderPoints)

        var drawBorder: Bool = true

        if path == nil {
            path = UIBezierPath()
            // Always draw in anti-clockwise to find the sides easier.

            switch edge {
            case .top, .bottom: // No verical edges
                return

            case .left:
                guard !(viewModel.customEdgeVisibility?.hideLeftEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideLeftEdge ?? false)

                point1 = CGPoint(x: 0, y: offSet/2)
                point2 = CGPoint(x: 0, y: offSetHeight + offSet/2)
                point3 = CGPoint(x: offSet, y: maxHeight)
                point4 = CGPoint(x: offSet, y: 0)
                point5 = CGPoint(x: 0, y: offSet/2)

            case .right:
                guard !(viewModel.customEdgeVisibility?.hideRightEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideRightEdge ?? false)

                point1 = CGPoint(x: offSetWidth, y: 0)
                point2 = CGPoint(x: offSetWidth, y: maxHeight)
                point3 = CGPoint(x: maxWidth, y: offSetHeight + offSet/2)
                point4 = CGPoint(x: maxWidth, y: offSet/2)
                point5 = CGPoint(x: offSetWidth, y: 0)

            // Inclined
            case .bottomRight:
                guard !(viewModel.customEdgeVisibility?.hideRightEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideRightEdge ?? false)

                point1 = CGPoint(x: offSetWidth, y: clippedOriginY)
                point2 = CGPoint(x: offSetWidth, y: offSetHeight)
                point3 = CGPoint(x: maxWidth, y: maxHeight)
                point4 = CGPoint(x: maxWidth, y: offSet)
                point5 = CGPoint(x: offSetWidth, y: clippedOriginY)

            case .bottomLeft:
                guard !(viewModel.customEdgeVisibility?.hideLeftEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideLeftEdge ?? false)

                point1 = CGPoint(x: 0, y: offSet)
                point2 = CGPoint(x: 0, y: maxHeight)
                point3 = CGPoint(x: offSet, y: offSetHeight)
                point4 = CGPoint(x: offSet, y: clippedOriginY)
                point5 = CGPoint(x: 0, y: offSet)

            case .topRight:
                guard !(viewModel.customEdgeVisibility?.hideRightEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideRightEdge ?? false)

                point1 = CGPoint(x: offSetWidth, y: offSet)
                point2 = CGPoint(x: offSetWidth, y: maxHeight)
                point3 = CGPoint(x: maxWidth, y: offSetHeight)
                point4 = CGPoint(x: maxWidth, y: clippedOriginY)
                point5 = CGPoint(x: offSetWidth, y: offSet)

            case .topLeft:
                guard !(viewModel.customEdgeVisibility?.hideLeftEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideLeftEdge ?? false)

                point1 = CGPoint(x: 0, y: clippedOriginY)
                point2 = CGPoint(x: 0, y: offSetHeight)
                point3 = CGPoint(x: offSet, y: maxHeight)
                point4 = CGPoint(x: offSet, y: offSet)
                point5 = CGPoint(x: 0, y: clippedOriginY)

            }
            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)
            path.addLine(to: point4)
            path.addLine(to: point5)
        } else {
            point1 = customBorderPoints.point1
            point2 = customBorderPoints.point2
            point3 = customBorderPoints.point3
            point4 = customBorderPoints.point4
            point5 = customBorderPoints.point5
        }

        path.close()

        let borderWidth = viewModel.borderWidth

        drawBorders(points: (point1, point2, point3, point4, point5),
                    colors: viewModel.verticalBorderColors,
                    borderWidth: borderWidth,
                    position: .vertical,
                    drawBorder: drawBorder,
                    layer: verticalEdgeLayer)

        verticalEdgeLayer.path = path.cgPath
        verticalEdgeLayer.lineWidth = 0
        verticalEdgeLayer.fillColor = color.cgColor
    }

    ///
    /// Draw horizontal edge of the `PopView`
    ///
    func drawHorizontalEdge(_ bounds: CGRect) {
        resetLayer(horizontalEdgeLayer)

        guard let viewModel = viewModel else {
            return
        }

        let offSetWidth = bounds.width - viewModel.edgeOffSet
        let offSetHeight = bounds.height - viewModel.edgeOffSet
        let offSet = viewModel.edgeOffSet

        let edge = viewModel.neoPopEdgeDirection
        let color = viewModel.horizontalEdgeColor

        var clippedOriginX: CGFloat = 0.0

        var maxWidth: CGFloat = bounds.width
        let maxHeight: CGFloat = bounds.height

        switch viewModel.clipsToOffSetWidth {
        case .none:
            break
        case .clipDistantCorners: // default case
            switch edge {
            case .bottomLeft, .topLeft:
                clippedOriginX = 0
                maxWidth = offSetWidth
            case .bottomRight, .topRight:
                clippedOriginX = offSet
                maxWidth = bounds.width
            default:
                clippedOriginX = 0
                maxWidth = offSetWidth
            }

        case .clipJoinedCorners: // special case
            switch edge {
            case .bottomLeft, .topLeft:
                clippedOriginX = offSet
                maxWidth = bounds.width

            case .bottomRight, .topRight:
                clippedOriginX = 0
                maxWidth = offSetWidth

            default:
                clippedOriginX = 0
                maxWidth = offSetWidth
            }

        }

        var point1: CGPoint = CGPoint.zero
        var point2: CGPoint = CGPoint.zero
        var point3: CGPoint = CGPoint.zero
        var point4: CGPoint = CGPoint.zero
        var point5: CGPoint = CGPoint.zero

        var customBorderPoints: CustomBorderDrawingPoints = CustomBorderDrawingPoints()
        var path: UIBezierPath! = viewModel.delegate?.getPathForHorizontalLayer(view: superview, frame: bounds, model: viewModel, borderPoints: &customBorderPoints)
        var drawBorder: Bool = true
        if path == nil {
            path = UIBezierPath()
            // Always draw in anti-clockwise to find the sides easier.

            switch edge {

            case .left, .right: // No edges
                return

            case .top:
                guard !(viewModel.customEdgeVisibility?.hideTopEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideTopEdge ??  false)

                point1 =  CGPoint(x: offSet/2, y: 0)
                point2 =  CGPoint(x: 0, y: offSet)
                point3 =  CGPoint(x: maxWidth, y: offSet)
                point4 =  CGPoint(x: offSetWidth + offSet/2, y: 0)
                point5 =  CGPoint(x: offSet/2, y: 0)

            case .bottom:
                guard !(viewModel.customEdgeVisibility?.hideBottomEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideBottomEdge ??  false)

                point1 = CGPoint(x: 0, y: offSetHeight)
                point2 = CGPoint(x: offSet/2, y: maxHeight)
                point3 = CGPoint(x: offSetWidth + offSet/2, y: maxHeight)
                point4 = CGPoint(x: maxWidth, y: offSetHeight)
                point5 = CGPoint(x: 0, y: offSetHeight)

            // Inclined
            case .bottomRight:
                guard !(viewModel.customEdgeVisibility?.hideBottomEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideBottomEdge ??  false)

                point1 =  CGPoint(x: clippedOriginX, y: offSetHeight)
                point2 =  CGPoint(x: offSet, y: maxHeight)
                point3 =  CGPoint(x: maxWidth, y: maxHeight)
                point4 =  CGPoint(x: offSetWidth, y: offSetHeight)
                point5 =  CGPoint(x: clippedOriginX, y: offSetHeight)

            case .bottomLeft:
                guard !(viewModel.customEdgeVisibility?.hideBottomEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideBottomEdge ??  false)

                point1 =  CGPoint(x: offSet, y: offSetHeight)
                point2 =  CGPoint(x: clippedOriginX, y: maxHeight)
                point3 =  CGPoint(x: offSetWidth, y: maxHeight)
                point4 =  CGPoint(x: maxWidth, y: offSetHeight)
                point5 =  CGPoint(x: offSet, y: offSetHeight)

            case .topRight:
                guard !(viewModel.customEdgeVisibility?.hideTopEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideTopEdge ??  false)

                point1 =  CGPoint(x: offSet, y: 0)
                point2 = CGPoint(x: clippedOriginX, y: offSet)
                point3 = CGPoint(x: offSetWidth, y: offSet)
                point4 = CGPoint(x: maxWidth, y: 0)
                point5 = CGPoint(x: offSet, y: 0)

            case .topLeft:
                guard !(viewModel.customEdgeVisibility?.hideTopEdge ?? false) else {
                    return
                }

                drawBorder = !(viewModel.customBorderVisibility?.hideTopEdge ??  false)

                point1 =  CGPoint(x: clippedOriginX, y: 0)
                point2 =  CGPoint(x: offSet, y: offSet)
                point3 =  CGPoint(x: maxWidth, y: offSet)
                point4 =  CGPoint(x: offSetWidth, y: 0)
                point5 =  CGPoint(x: clippedOriginX, y: 0)

            }
            path.move(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)
            path.addLine(to: point4)
            path.addLine(to: point5)
        } else {
            point1 = customBorderPoints.point1
            point2 = customBorderPoints.point2
            point3 = customBorderPoints.point3
            point4 = customBorderPoints.point4
            point5 = customBorderPoints.point5
        }

        path.close()

        let borderWidth: CGFloat = viewModel.borderWidth

        drawBorders(points: (point1, point2, point3, point4, point5),
                    colors: viewModel.horizontalBorderColors,
                    borderWidth: borderWidth,
                    position: .horizontal,
                    drawBorder: drawBorder,
                    layer: horizontalEdgeLayer)

        horizontalEdgeLayer.path = path.cgPath
        horizontalEdgeLayer.lineWidth = 0
        horizontalEdgeLayer.fillColor = color.cgColor
    }

}

// MARK: Custom Border
private extension PopView {
    typealias EdgePoints = (point1: CGPoint, point2: CGPoint, point3: CGPoint, point4: CGPoint, point5: CGPoint)

    enum Position {
        case center
        case vertical
        case horizontal
    }

    func drawBorders(points: EdgePoints,
                     colors: EdgeColors?,
                     borderWidth: CGFloat,
                     position: Position,
                     drawBorder: Bool,
                     layer: PopContentLayer) {

        let topBottomBorderScaling: CGFloat
        let leftRightBorderScaling: CGFloat

        switch position {
        case .center:
            topBottomBorderScaling = 1
            leftRightBorderScaling = 1
        case .vertical:
            topBottomBorderScaling = 1
            leftRightBorderScaling = 2
        case .horizontal:
            topBottomBorderScaling = 2
            leftRightBorderScaling = 1
        }

        if let color = colors?.left, drawBorder {
            layer.configureBorders(withModel: PopContentLayer.BorderModel(start: points.point1, end: points.point2, color: color, borderWidth: leftRightBorderScaling * borderWidth), for: .left)
        } else {
            layer.hideBorder(on: .left)
        }

        if let color = colors?.bottom, drawBorder {
            layer.configureBorders(withModel: PopContentLayer.BorderModel(start: points.point2, end: points.point3, color: color, borderWidth: topBottomBorderScaling * borderWidth), for: .bottom)
        } else {
            layer.hideBorder(on: .bottom)
        }

        if let color = colors?.right, drawBorder {
            layer.configureBorders(withModel: PopContentLayer.BorderModel(start: points.point3, end: points.point4, color: color, borderWidth: leftRightBorderScaling * borderWidth), for: .right)
        } else {
            layer.hideBorder(on: .right)
        }

        if let color = colors?.top, drawBorder {
            layer.configureBorders(withModel: PopContentLayer.BorderModel(start: points.point4, end: points.point5, color: color, borderWidth: topBottomBorderScaling * borderWidth), for: .top)
        } else {
            layer.hideBorder(on: .top)
        }
    }
}
