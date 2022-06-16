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
        let view = UIImageView(image: UIImage(named: ImageConstants.popButtonText))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let elevatedButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model(
                position: .bottomRight,
                backgroundColor: ColorHelper.popWhite500
            )
        )
        button.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.payNow),
                leftImageScale: 3
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let flatButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model(
                position: .center,
                backgroundColor: ColorHelper.popWhite500,
                superViewColor: ColorHelper.popBlack400
            )
        )
        button.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.payNow),
                leftImageScale: 3
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let elevatedStrokeButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model(
                position: .bottomRight,
                backgroundColor: ColorHelper.popBlack500,
                buttonFaceBorderColor: EdgeColors(
                    color: ColorHelper.popWhite500
                ),
                borderWidth: 0.31,
                edgeLength: 1.87,
                customEdgeColor: EdgeColors(
                    left: nil,
                    right: PopHelper.horizontalEdgeColor(for: ColorHelper.popWhite500),
                    top: nil,
                    bottom: PopHelper.verticalEdgeColor(for: ColorHelper.popWhite500)
                )
            )
        )
        button.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.payNowWithArrow),
                leftImageScale: 5.03
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let flatStrokeButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model(
                position: .center,
                backgroundColor: ColorHelper.popBlack500,
                superViewColor: ColorHelper.popBlack400,
                buttonFaceBorderColor: EdgeColors(
                    color: ColorHelper.popWhite500
                ),
                borderWidth: 0.31,
                edgeLength: 1.87
            )
        )
        button.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.payNowWithArrow),
                leftImageScale: 5.03
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let scanButton: PopButton = {
        let button = PopButton()
        button.configurePopButton(
            withModel: PopButton.Model(
                position: .bottomRight,
                backgroundColor: ColorHelper.popBlack500,
                buttonFaceBorderColor: EdgeColors(
                    color: ColorHelper.popGreen100
                ),
                borderWidth: 0.31,
                edgeLength: 1.68,
                customEdgeColor: EdgeColors(
                    left: nil,
                    right: ColorHelper.popGreen200,
                    top: nil,
                    bottom: ColorHelper.popGreen300
                )
            )
        )
        button.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.scanButtonText),
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

        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.elevatedButton, button: elevatedButton, buttonHeight: 37))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.flatbutton, button: flatButton, buttonHeight: 37))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.elevatedStokeButton, button: elevatedStrokeButton, buttonHeight: 30))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.flatStrokeButton, button: flatStrokeButton, buttonHeight: 30))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.scanButton, button: scanButton, buttonHeight: 30))
    }
}
