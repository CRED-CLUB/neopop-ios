//
//  ShowCaseView.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit

struct ColorModel {
    var top: UIColor
    var left: UIColor
    var right: UIColor
    var bottom: UIColor

    init(top: UIColor, left: UIColor, right: UIColor, bottom: UIColor) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }

    init(_ color: UIColor) {
        self.init(top: color, left: color, right: color, bottom: color)
    }
}

struct ShowCaseViewModel {
    var fillColorModel: ColorModel
    var strokeColorModel: UIColor
    var borderThickness: CGFloat
    var edgeThickness: CGFloat
    var bottomEdgeThickness: CGFloat

    static var defaultValue: Self {
        ShowCaseViewModel(fillColorModel: Self.defaultFillColor, strokeColorModel: Self.defaultStrokeColor, borderThickness: 0.5, edgeThickness: 7, bottomEdgeThickness: 7)
    }

    private static var defaultFillColor: ColorModel {
        ColorModel(top: UIColor(fromHex: "#3B3D3C"), left: UIColor(fromHex: "#1F1F1F"), right: UIColor(fromHex: "#282427"), bottom: UIColor(fromHex: "#1F1F1F"))
    }

    private static var defaultStrokeColor: UIColor {
        .black
    }
}

final class ShowCaseView: UIView {
    private let topFrameLayer = CAShapeLayer()
    private let leftFrameLayer = CAShapeLayer()
    private let rightFrameLayer = CAShapeLayer()
    private let bottomFrameLayer = CAShapeLayer()
    private let borderLayer = CAShapeLayer()

    // MARK: Public Properties
    let contentView = UIView()

    private(set) var viewModel: ShowCaseViewModel = ShowCaseViewModel.defaultValue {
        didSet {
            updateLayerAppearence()
            setNeedsDisplay()
        }
    }

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Overriden Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        let edgeThickness = viewModel.edgeThickness
        contentView.frame = CGRect(x: edgeThickness, y: edgeThickness, width: bounds.width - edgeThickness * 2, height: bounds.height - edgeThickness * 2)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTopFrame(rect)
        drawLeftFrame(rect)
        drawRightFrame(rect)
        drawBottomFrame(rect)
        drawBorder(rect)
    }

    // MARK: Public Methods
    func applyStyle(_ viewModel: ShowCaseViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: Private Methods
private extension ShowCaseView {
    private func setup() {
        addSubview(contentView)
        layer.addSublayer(topFrameLayer)
        layer.addSublayer(leftFrameLayer)
        layer.addSublayer(rightFrameLayer)
        layer.addSublayer(bottomFrameLayer)
        layer.addSublayer(borderLayer)
        borderLayer.fillColor = nil
        updateLayerAppearence()
    }
}

// MARK: View update methods
private extension ShowCaseView {
    func updateLayerAppearence() {
        updateFillColor()
        updateStroke()
    }

    func updateFillColor() {
        let fillColorModel = viewModel.fillColorModel
        topFrameLayer.fillColor = fillColorModel.top.cgColor
        leftFrameLayer.fillColor = fillColorModel.left.cgColor
        rightFrameLayer.fillColor = fillColorModel.right.cgColor
        bottomFrameLayer.fillColor = fillColorModel.bottom.cgColor
    }

    func updateStroke() {
        let strokeColorModel = viewModel.strokeColorModel
        borderLayer.strokeColor = strokeColorModel.cgColor
        borderLayer.lineWidth = viewModel.borderThickness
    }
}

// MARK: View Draw Methods
private extension ShowCaseView {
    private func drawTopFrame(_ rect: CGRect) {
        let edgeThickness = viewModel.edgeThickness
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width-edgeThickness, y: edgeThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: edgeThickness))
        path.close()
        topFrameLayer.path = path.cgPath
    }

    private func drawLeftFrame(_ rect: CGRect) {
        let edgeThickness = viewModel.edgeThickness
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: edgeThickness, y: rect.height - edgeThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: edgeThickness))
        path.close()
        leftFrameLayer.path = path.cgPath
    }

    private func drawRightFrame(_ rect: CGRect) {
        let edgeThickness = viewModel.edgeThickness
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - edgeThickness, y: rect.height - edgeThickness))
        path.addLine(to: CGPoint(x: rect.width - edgeThickness, y: edgeThickness))
        path.close()
        rightFrameLayer.path = path.cgPath
    }

    private func drawBottomFrame(_ rect: CGRect) {
        let edgeThickness = viewModel.edgeThickness
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - edgeThickness, y: rect.height - viewModel.bottomEdgeThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: rect.height - viewModel.bottomEdgeThickness))
        path.close()
        bottomFrameLayer.path = path.cgPath
    }

    private func drawBorder(_ rect: CGRect) {
        let borderThickness = viewModel.borderThickness/2
        let edgeThickness = viewModel.edgeThickness - borderThickness
        let path = UIBezierPath()
        // Top Layer
        path.move(to: CGPoint(x: borderThickness, y: borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: borderThickness))
        path.addLine(to: CGPoint(x: rect.width - edgeThickness, y: edgeThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: edgeThickness))
        path.addLine(to: CGPoint(x: borderThickness, y: borderThickness))
        path.addLine(to: CGPoint(x: borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: rect.height - viewModel.bottomEdgeThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: edgeThickness))

        // Left Layer
        path.move(to: CGPoint(x: borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - edgeThickness, y: rect.height - viewModel.bottomEdgeThickness))
        path.addLine(to: CGPoint(x: edgeThickness, y: rect.height - viewModel.bottomEdgeThickness))

        // Bottom Layer
        path.move(to: CGPoint(x: rect.width - borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: borderThickness))

        // Right Layer
        path.move(to: CGPoint(x: rect.width - edgeThickness, y: edgeThickness))
        path.addLine(to: CGPoint(x: rect.width - edgeThickness, y: rect.height - viewModel.bottomEdgeThickness))

        borderLayer.path = path.cgPath
    }
}
