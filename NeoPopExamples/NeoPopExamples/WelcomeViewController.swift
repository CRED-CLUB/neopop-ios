//
//  WelcomeViewController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit
import NeoPop

protocol WelcomeViewControllerDelegate: AnyObject {
    func mainButtonClicked()
    func primaryButtonClicked()
    func secondaryButtonClicked()
    func switchButtonClicked()
}

final class WelcomeViewController: UIViewController {
    private let welcomeTextLayoutGuide = UILayoutGuide()

    // MARK: View properties
    private let logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageConstants.credLogo)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let welcomeText: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageConstants.welcomeText)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    weak var delegate: WelcomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Constraints and setup
        addCREDLogo()

        addWelcomeText()

        addButtonStackView()

        addButtons()
    }

    @objc
    private func ctaClicked(_ button: PopButton) {
        switch button.tag {
        case 1:
            delegate?.mainButtonClicked()
        case 2:
            delegate?.primaryButtonClicked()
        case 3:
            delegate?.secondaryButtonClicked()
        case 4:
            delegate?.switchButtonClicked()
        default:
            break
        }
    }
}

// MARK: View Setup
private extension WelcomeViewController {

    func addCREDLogo() {
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.05),
            logo.heightAnchor.constraint(equalToConstant: 44),
            logo.widthAnchor.constraint(equalToConstant: 33),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func addWelcomeText() {
        view.addLayoutGuide(welcomeTextLayoutGuide)
        NSLayoutConstraint.activate([
            welcomeTextLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeTextLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeTextLayoutGuide.topAnchor.constraint(equalTo: logo.bottomAnchor)
        ])

        view.addSubview(welcomeText)
        NSLayoutConstraint.activate([
            welcomeText.heightAnchor.constraint(equalTo: welcomeText.widthAnchor, multiplier: 0.54),
            welcomeText.widthAnchor.constraint(equalTo: welcomeTextLayoutGuide.widthAnchor, multiplier: 0.62),
            welcomeText.bottomAnchor.constraint(equalTo: welcomeTextLayoutGuide.bottomAnchor),
            welcomeText.topAnchor.constraint(equalTo: welcomeTextLayoutGuide.topAnchor, constant: view.frame.height * 0.1),
            welcomeText.centerXAnchor.constraint(equalTo: welcomeTextLayoutGuide.centerXAnchor)
        ])
    }

    private func addButtonStackView() {
        let stackLayoutGuide = UILayoutGuide()
        view.addLayoutGuide(stackLayoutGuide)
        NSLayoutConstraint.activate([
            stackLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            stackLayoutGuide.topAnchor.constraint(equalTo: welcomeTextLayoutGuide.bottomAnchor),
            stackLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: stackLayoutGuide.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: stackLayoutGuide.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: stackLayoutGuide.leadingAnchor),
            buttonStackView.topAnchor.constraint(greaterThanOrEqualTo: stackLayoutGuide.topAnchor)
        ])
    }

    func addButtons() {
        var index = 1
        [
            (ImageConstants.tiltButtonsWithArrow, 6.32),
            (ImageConstants.popButtonsWithArrow, 7.27),
            (ImageConstants.advancedWithArrow, 8.4),
            (ImageConstants.switchesWithArrow, 4.8)
        ].forEach({

            let button = PopButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.configurePopButton(
                withModel: PopButton.Model(
                    position: .center,
                    backgroundColor: ColorHelper.contentBackgroundColor,
                    superViewColor: ColorHelper.contentBackgroundColor,
                    buttonFaceBorderColor: EdgeColors(
                        color: ColorHelper.popWhite500
                    ),
                    borderWidth: 0.4
                )
            )
            button.configureButtonContent(
                withModel: PopButtonContainerView.Model(
                    attributedTitle: nil,
                    leftImage: UIImage(named: $0.0),
                    leftImageScale: $0.1,
                    contentLeftRightInset: 0
                )
            )
            button.tag = index
            button.addTarget(self, action: #selector(ctaClicked(_:)), for: .touchUpInside)

            buttonStackView.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true

            index += 1
        })
    }
}
