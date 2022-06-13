//
//  PopButtonsViewController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit
import NeoPop

final class PopButtonsViewController: UIViewController {

    // MARK: View properties
    private let titleLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: "pop button"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let elevatedButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model.createButtonModel(
                position: .bottomRight,
                buttonColor: ColorHelper.popWhite500
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "pay now"),
                leftImageScale: 3
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let flatButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model.createButtonModel(
                position: .center,
                buttonColor: ColorHelper.popWhite500,
                superViewColor: ColorHelper.popBlack400
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "pay now"),
                leftImageScale: 3
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let elevatedStrokeButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model.createButtonModel(
                position: .bottomRight,
                buttonColor: ColorHelper.popBlack500,
                buttonFaceBorderColor: EdgeColors(
                    color: ColorHelper.popWhite500
                ),
                borderWidth: 0.31,
                edgeWidth: 1.87,
                customEdgeColor: EdgeColors(
                    left: nil,
                    right: PopHelper.horizontalEdgeColor(for: ColorHelper.popWhite500),
                    top: nil,
                    bottom: PopHelper.verticalEdgeColor(for: ColorHelper.popWhite500)
                )
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "pay now arrow"),
                leftImageScale: 5.03
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let flatStrokeButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model.createButtonModel(
                position: .center,
                buttonColor: ColorHelper.popBlack500,
                superViewColor: ColorHelper.popBlack400,
                buttonFaceBorderColor: EdgeColors(
                    color: ColorHelper.popWhite500
                ),
                borderWidth: 0.31,
                edgeWidth: 1.87
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "pay now arrow"),
                leftImageScale: 5.03
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let scanButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model.createButtonModel(
                position: .bottomRight,
                buttonColor: ColorHelper.popBlack500,
                buttonFaceBorderColor: EdgeColors(
                    color: UIColor.fromHex("#8DD04A")
                ),
                borderWidth: 0.31,
                edgeWidth: 1.68,
                customEdgeColor: EdgeColors(
                    left: nil,
                    right: PopHelper.horizontalEdgeColor(for: UIColor.fromHex("#629F25")),
                    top: nil,
                    bottom: PopHelper.verticalEdgeColor(for: UIColor.fromHex("3F6915"))
                )
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "scan_button_text"),
                leftImageScale: 7.44
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.distribution = .equalSpacing
        contentStackView.axis = .vertical

        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor, multiplier: 0.75),
            contentStackView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
            contentStackView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor, multiplier: 0.8)
        ])

        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "ELEVATED BUTTON", button: elevatedButton, buttonHeight: 37))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "FLAT BUTTON", button: flatButton, buttonHeight: 37))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "ELEVATED STROKE BUTTON", button: elevatedStrokeButton, buttonHeight: 30))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "FLAT STROKE BUTTON", button: flatStrokeButton, buttonHeight: 30))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "SCAN BUTTON", button: scanButton, buttonHeight: 30))
    }
}
