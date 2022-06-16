//
//  SwitchesViewController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit
import NeoPop

final class SwitchesViewController: UIViewController {

    private let containerLayoutGuide = UILayoutGuide()

    // MARK: View properties
    private let titleLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageConstants.switches))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let toggleLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageConstants.toggle))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let switchView: PopSwitch = {
        let view = PopSwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let checkboxLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageConstants.checkBox))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let checkBox: PopCheckBox = {
        let view = PopCheckBox()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let radioButtonLabel: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageConstants.radioButton))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let radioButton: PopRadioButton = {
        let view = PopRadioButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

        view.addLayoutGuide(containerLayoutGuide)

        NSLayoutConstraint.activate([
            containerLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerLayoutGuide.topAnchor.constraint(greaterThanOrEqualTo: contentLayoutGuide.topAnchor),
            containerLayoutGuide.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor)
        ])

        addRadioButton()
        addCheckBox()
        addSwitch()
    }
}

private extension SwitchesViewController {
    func addRadioButton() {
        view.addSubview(radioButtonLabel)
        NSLayoutConstraint.activate([
            radioButtonLabel.leadingAnchor.constraint(equalTo: containerLayoutGuide.leadingAnchor, constant: 30),
            radioButtonLabel.topAnchor.constraint(equalTo: containerLayoutGuide.topAnchor)
        ])

        view.addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.centerXAnchor.constraint(equalTo: radioButtonLabel.centerXAnchor),
            radioButton.topAnchor.constraint(equalTo: radioButtonLabel.bottomAnchor, constant: 15)
        ])
    }

    func addCheckBox() {
        view.addSubview(checkboxLabel)
        NSLayoutConstraint.activate([
            checkboxLabel.trailingAnchor.constraint(equalTo: containerLayoutGuide.trailingAnchor, constant: -30),
            checkboxLabel.topAnchor.constraint(equalTo: radioButtonLabel.topAnchor)
        ])

        view.addSubview(checkBox)
        NSLayoutConstraint.activate([
            checkBox.centerXAnchor.constraint(equalTo: checkboxLabel.centerXAnchor),
            checkBox.topAnchor.constraint(equalTo: checkboxLabel.bottomAnchor, constant: 15)
        ])
    }

    func addSwitch() {
        view.addSubview(toggleLabel)
        NSLayoutConstraint.activate([
            toggleLabel.centerXAnchor.constraint(equalTo: containerLayoutGuide.centerXAnchor),
            toggleLabel.topAnchor.constraint(equalTo: radioButton.bottomAnchor, constant: view.frame.height * 0.075)
        ])

        view.addSubview(switchView)
        NSLayoutConstraint.activate([
            switchView.centerXAnchor.constraint(equalTo: containerLayoutGuide.centerXAnchor),
            switchView.topAnchor.constraint(equalTo: toggleLabel.bottomAnchor, constant: 15),
            switchView.bottomAnchor.constraint(equalTo: containerLayoutGuide.bottomAnchor)
        ])
    }
}
