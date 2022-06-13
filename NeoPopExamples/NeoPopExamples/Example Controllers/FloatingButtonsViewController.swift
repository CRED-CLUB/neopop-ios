//
//  FloatingButtonsViewController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit
import NeoPop

final class FloatingButtonsViewController: UIViewController {

    // MARK: View properties
    private let titleLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: "tilt button"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let floatingButton: PopFloatingButton = {
        let button = PopFloatingButton()
        button.startLevitatingMotion()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureFloatingButton(
            withModel: PopFloatingButton.Model(
                buttonColor: ColorHelper.winYellow500,
                edgeWidth: 9,
                shimmerModel: PopShimmerModel(
                    spacing: 10,
                    lineColor1: ColorHelper.popWhite500,
                    lineColor2: ColorHelper.popWhite500,
                    lineWidth1: 16,
                    lineWidth2: 35,
                    duration: 2,
                    delay: 5
                )
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                rightImage: UIImage(named: "play_now_text"),
                rightImageScale: 4.81
            )
        )
        button.startShimmerAnimation()
        return button
    }()

    private let nonFloatingButton: PopFloatingButton = {
        let button = PopFloatingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureFloatingButton(
            withModel: PopFloatingButton.Model(
                buttonColor: ColorHelper.popWhite500,
                shadowColor: UIColor.black,
                edgeWidth: 9
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "view_text"),
                leftImageScale: 3.1
            )
        )
        return button
    }()

    private let floatingStrokeButton: PopFloatingButton = {
        let button = PopFloatingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureFloatingButton(
            withModel: PopFloatingButton.Model(
                buttonColor: ColorHelper.popBlack500,
                shadowColor: UIColor.black,
                edgeWidth: 9,
                customEdgeColor: UIColor.fromHex("#3F6915"),
                borderColor: UIColor.fromHex("#8DD04A"),
                borderWidth: 0.31,
                shimmerModel: PopShimmerModel(
                    spacing: 10,
                    lineColor1: ColorHelper.popWhite500,
                    lineColor2: ColorHelper.popWhite500,
                    lineWidth1: 16,
                    lineWidth2: 35,
                    duration: 2,
                    delay: 5
                )
            )
        )
        button.configureButtonContent(
            withModel: CustomButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: "play_now_text"),
                leftImageTintColor: UIColor.white,
                leftImageScale: 4.81
            )
        )
        button.startLevitatingMotion()
        button.startShimmerAnimation()
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
        contentStackView.distribution = .fill
        contentStackView.spacing = view.frame.height * 0.05
        contentStackView.axis = .vertical

        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor, multiplier: 0.75),
            contentStackView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: contentLayoutGuide.topAnchor)
        ])

        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "FLOATING TILT BUTTON", button: floatingButton, buttonHeight: 55, spacing: 15))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "NON FLOATING TILT BUTTON", button: nonFloatingButton, buttonHeight: 55, spacing: 15))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: "FLOATING STROKE TILT BUTTON", button: floatingStrokeButton, buttonHeight: 55, spacing: 15))
    }
}
