//
//  TiltButtonsViewController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit
import NeoPop

final class TiltButtonsViewController: UIViewController {

    // MARK: View properties
    private let titleLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageConstants.tiltButton))
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
                backgroundColor: ColorHelper.popYellow500,
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
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                rightImage: UIImage(named: ImageConstants.playNowText),
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
                backgroundColor: ColorHelper.popWhite500,
                shadowColor: UIColor.black,
                edgeWidth: 9
            )
        )
        button.configureButtonContent(
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.viewText),
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
                backgroundColor: ColorHelper.popBlack500,
                shadowColor: UIColor.black,
                edgeWidth: 9,
                customEdgeColor: ColorHelper.popGreen300,
                borderColor: ColorHelper.popGreen100,
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
            withModel: PopButtonContainerView.Model(
                attributedTitle: nil,
                leftImage: UIImage(named: ImageConstants.playNowText),
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

        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.floatingTiltButton, button: floatingButton, buttonHeight: 55, spacing: 15))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.nonFloatingTiltButton, button: nonFloatingButton, buttonHeight: 55, spacing: 15))
        contentStackView.addArrangedSubview(UIHelper.getContainerViewFor(text: ImageConstants.floatingStrokeTiltButton, button: floatingStrokeButton, buttonHeight: 55, spacing: 15))
    }
}
