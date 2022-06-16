//
//  AdvancedButtonsViewController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit
import NeoPop

class AdvancedButtonsViewController: UIViewController {

    // MARK: View properties
    private let titleLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageConstants.advanced))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.distribution = .equalSpacing
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        return contentStackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Constraints and setup

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 45),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.06)
        ])

        let contentLayoutGuide = UILayoutGuide()
        view.addLayoutGuide(contentLayoutGuide)
        NSLayoutConstraint.activate([
            contentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentLayoutGuide.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor, multiplier: 0.75),
            contentStackView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
            contentStackView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor, multiplier: 0.7)
        ])

        contentStackView.addArrangedSubview(getAdjacentButtons())
        contentStackView.addArrangedSubview(getConfigButtons())
    }
}

// MARK: Adjacent Buttons
private extension AdvancedButtonsViewController {
    func getAdjacentButtons() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .center

        let titleView = getTitleView(ImageConstants.adjacentButtons)
        titleView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.addArrangedSubview(titleView)

        let borderColor = ColorHelper.popGreen100
        let bottomEdge = ColorHelper.popGreen300
        let rightEdge = ColorHelper.popGreen200

        let topLeftButton = getPopButton(
            position: .topLeft,
            color: ColorHelper.popWhite500,
            tintColor: ColorHelper.contentBackgroundColor,
            superViewColor: ColorHelper.contentBackgroundColor,
            adjacentButtonModel: AdjacentButtonAvailability(bottom: true, right: true)
        )

        let topCenterButton = getPopButton(
            position: .topEdge,
            color: ColorHelper.contentBackgroundColor,
            tintColor: ColorHelper.popWhite500,
            superViewColor: ColorHelper.popWhite500,
            borderColor: borderColor,
            adjacentButtonModel: AdjacentButtonAvailability(bottom: true, right: true, left: true)
        )

        let topRightButton = getPopButton(
            position: .topRight,
            color: ColorHelper.popWhite500,
            tintColor: ColorHelper.contentBackgroundColor,
            superViewColor: ColorHelper.contentBackgroundColor, adjacentButtonModel: AdjacentButtonAvailability(bottom: true, left: true)
        )

        let bottomLeftbutton = getPopButton(
            position: .bottomLeft,
            color: ColorHelper.contentBackgroundColor,
            tintColor: ColorHelper.popWhite500,
            superViewColor: ColorHelper.popWhite500,
            borderColor: borderColor,
            edgeColor: EdgeColors(color: bottomEdge),
            adjacentButtonModel: AdjacentButtonAvailability(top: true, right: true)
        )

        let bottomCenterbutton = getPopButton(
            position: .bottomEdge,
            color: ColorHelper.popWhite500,
            tintColor: ColorHelper.contentBackgroundColor,
            superViewColor: ColorHelper.contentBackgroundColor,
            adjacentButtonModel: AdjacentButtonAvailability(top: true, right: true, left: true)
        )

        let bottomRightButton = getPopButton(
            position: .bottomRight,
            color: ColorHelper.contentBackgroundColor,
            tintColor: ColorHelper.popWhite500,
            superViewColor: ColorHelper.popWhite500,
            borderColor: borderColor,
            edgeColor: EdgeColors(left: nil, right: rightEdge, top: nil, bottom: bottomEdge),
            adjacentButtonModel: AdjacentButtonAvailability(top: true, left: true)
        )

        let buttonsContentStackView = UIStackView()
        buttonsContentStackView.axis = .vertical
        buttonsContentStackView.spacing = -3
        stackView.addArrangedSubview(buttonsContentStackView)

        let firstButtonRow = UIStackView()
        firstButtonRow.axis = .horizontal
        firstButtonRow.spacing = -3
        firstButtonRow.translatesAutoresizingMaskIntoConstraints = false
        buttonsContentStackView.addArrangedSubview(firstButtonRow)
        firstButtonRow.heightAnchor.constraint(equalToConstant: 37).isActive = true

        firstButtonRow.addArrangedSubview(topLeftButton)
        topLeftButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        firstButtonRow.addArrangedSubview(topCenterButton)
        topCenterButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        firstButtonRow.addArrangedSubview(topRightButton)
        topRightButton.widthAnchor.constraint(equalToConstant: 63).isActive = true

        let secondButtonRow = UIStackView()
        secondButtonRow.axis = .horizontal
        secondButtonRow.spacing = -3
        secondButtonRow.translatesAutoresizingMaskIntoConstraints = false
        buttonsContentStackView.addArrangedSubview(secondButtonRow)
        secondButtonRow.heightAnchor.constraint(equalToConstant: 40).isActive = true

        secondButtonRow.addArrangedSubview(bottomLeftbutton)
        bottomLeftbutton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        secondButtonRow.addArrangedSubview(bottomCenterbutton)
        bottomCenterbutton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        secondButtonRow.addArrangedSubview(bottomRightButton)
        bottomRightButton.widthAnchor.constraint(equalToConstant: 63).isActive = true

        return stackView
    }
}

// MARK: Config Buttons
private extension AdvancedButtonsViewController {
    func getConfigButtons() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .center

        let titleView = getTitleView(ImageConstants.configButtons)
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalToConstant: 8),
            titleView.widthAnchor.constraint(equalToConstant: 70)
        ])
        stackView.addArrangedSubview(titleView)

        let popView = PopView()
        popView.applyNeoPopStyle(
            model: PopView.Model(
                neoPopEdgeDirection: .bottomRight,
                backgroundColor: ColorHelper.contentBackgroundColor
            )
        )
        popView.isUserInteractionEnabled = true
        popView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popView.heightAnchor.constraint(equalToConstant: 138),
            popView.widthAnchor.constraint(equalToConstant: 153)
        ])
        stackView.addArrangedSubview(popView)

        let bottomEdge = ColorHelper.popGreen300
        let rightEdge = ColorHelper.popGreen200

        let topLeftButton = getConfigButton(
            position: .topLeft
        )

        let topCenterButton = getConfigButton(
            position: .topEdge
        )

        let topRightButton = getConfigButton(
            position: .topRight,
            edgeColor: EdgeColors(left: nil, right: rightEdge, top: nil, bottom: nil)
        )

        let middleLeftButton = getConfigButton(position: .leftEdge)

        let middleCenterButton = getConfigButton(position: .center)

        let middleRightButton = getConfigButton(
            position: .rightEdge,
            edgeColor: EdgeColors(left: nil, right: rightEdge, top: nil, bottom: nil)
        )

        let bottomLeftbutton = getConfigButton(
            position: .bottomLeft,
            edgeColor: EdgeColors(left: nil, right: nil, top: nil, bottom: bottomEdge)
        )

        let bottomCenterbutton = getConfigButton(
            position: .bottomEdge,
            edgeColor: EdgeColors(left: nil, right: nil, top: nil, bottom: bottomEdge)
        )

        let bottomRightButton = getConfigButton(
            position: .bottomRight,
            edgeColor: EdgeColors(left: nil, right: rightEdge, top: nil, bottom: bottomEdge)
        )

        let buttonsContentStackView = UIStackView()
        buttonsContentStackView.axis = .vertical
        buttonsContentStackView.distribution = .equalSpacing
        popView.addSubview(buttonsContentStackView)
        buttonsContentStackView.fillSuperview()

        let topbuttonRow = UIStackView()
        topbuttonRow.axis = .horizontal
        topbuttonRow.distribution = .equalSpacing
        topbuttonRow.translatesAutoresizingMaskIntoConstraints = false
        buttonsContentStackView.addArrangedSubview(topbuttonRow)
        topbuttonRow.heightAnchor.constraint(equalToConstant: 40).isActive = true

        topbuttonRow.addArrangedSubview(topLeftButton)
        topLeftButton.widthAnchor.constraint(equalToConstant: 43).isActive = true
        topbuttonRow.addArrangedSubview(topCenterButton)
        topCenterButton.widthAnchor.constraint(equalToConstant: 43).isActive = true
        topbuttonRow.addArrangedSubview(topRightButton)
        topRightButton.widthAnchor.constraint(equalToConstant: 43).isActive = true

        let middleButtonRow = UIStackView()
        middleButtonRow.axis = .horizontal
        middleButtonRow.distribution = .equalSpacing
        middleButtonRow.translatesAutoresizingMaskIntoConstraints = false
        buttonsContentStackView.addArrangedSubview(middleButtonRow)
        middleButtonRow.heightAnchor.constraint(equalToConstant: 40).isActive = true

        middleButtonRow.addArrangedSubview(middleLeftButton)
        middleLeftButton.widthAnchor.constraint(equalToConstant: 43).isActive = true
        middleButtonRow.addArrangedSubview(middleCenterButton)
        middleCenterButton.widthAnchor.constraint(equalToConstant: 43).isActive = true
        middleButtonRow.addArrangedSubview(middleRightButton)
        middleRightButton.widthAnchor.constraint(equalToConstant: 43).isActive = true

        let bottomButtonRow = UIStackView()
        bottomButtonRow.axis = .horizontal
        bottomButtonRow.distribution = .equalSpacing
        bottomButtonRow.translatesAutoresizingMaskIntoConstraints = false
        buttonsContentStackView.addArrangedSubview(bottomButtonRow)
        bottomButtonRow.heightAnchor.constraint(equalToConstant: 40).isActive = true

        bottomButtonRow.addArrangedSubview(bottomLeftbutton)
        bottomLeftbutton.widthAnchor.constraint(equalToConstant: 43).isActive = true
        bottomButtonRow.addArrangedSubview(bottomCenterbutton)
        bottomCenterbutton.widthAnchor.constraint(equalToConstant: 43).isActive = true
        bottomButtonRow.addArrangedSubview(bottomRightButton)
        bottomRightButton.widthAnchor.constraint(equalToConstant: 43).isActive = true

        return stackView
    }

    func getConfigButton(position: PopButton.Position,
                         edgeColor: EdgeColors? = nil,
                         adjacentButtonModel: AdjacentButtonAvailability? = nil) -> UIView {
        getPopButton(position: position, color: ColorHelper.contentBackgroundColor, tintColor: ColorHelper.popWhite500, superViewColor: ColorHelper.contentBackgroundColor, borderColor: ColorHelper.popGreen100, edgeColor: edgeColor, imageScale: 2, adjacentButtonModel: adjacentButtonModel)
    }
}

// MARK: Common Methods
private extension AdvancedButtonsViewController {
    func getPopButton(position: PopButton.Position,
                      color: UIColor,
                      tintColor: UIColor,
                      superViewColor: UIColor,
                      borderColor: UIColor? = nil,
                      edgeColor: EdgeColors? = nil,
                      imageScale: CGFloat = 2.33,
                      adjacentButtonModel: AdjacentButtonAvailability? = nil) -> UIView {
        let popButton = PopButton()
        popButton.translatesAutoresizingMaskIntoConstraints = false

        popButton.configurePopButton(
            withModel: PopButton.Model(
                position: position,
                backgroundColor: color,
                superViewColor: superViewColor,
                buttonFaceBorderColor: EdgeColors(color: borderColor),
                borderWidth: 0.31,
                customEdgeColor: edgeColor
            )
        )

        popButton.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                leftImage: UIImage(named: ImageConstants.button),
                leftImageTintColor: tintColor,
                leftImageScale: imageScale,
                contentLeftRightInset: 0
            )
        )
        return popButton
    }

    func getTitleView(_ text: String) -> UIView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: text)!
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
