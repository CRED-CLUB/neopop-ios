//
//  PopButtonContainerView.swift
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

///
/// A custom container view written for rendering the content of ``PopButton`` and ``PopFloatingButton``
///
open class PopButtonContainerView: UIView, PopButtonCustomContainerDrawable {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 8
        view.axis = .horizontal
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var stackViewLeadingConstraint: NSLayoutConstraint!
    private var leftImageWidthConstraint: NSLayoutConstraint!
    private var rightImageWidthConstraint: NSLayoutConstraint!

    public let leftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let rightImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public init() {
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    /// Use this method to configure ``PopButtonContainerView/titleLabel``, ``PopButtonContainerView/leftImageView``, ``PopButtonContainerView/rightImageView``.
    ///
    /// - Parameter model: the model which contains all the properties related to appearance of the ``PopButtonContainerView``
    ///
    /// refer ``PopButtonContainerView/Model`` for configurable properties.
    ///
    open func configureView(withModel model: Model) {
        // Set TitleText
        if let attributedTitle = model.attributedTitle {
            titleLabel.attributedText = attributedTitle
        } else if let titleText =  model.title {
            titleLabel.text = titleText
        } else {
            titleLabel.isHidden = true
        }

        // Set left image icon
        updateLeftImage(withModel: model)

        // Set right image icon
        updateRightImage(withModel: model)

        // button content Insets
        stackViewLeadingConstraint.constant = model.contentLeftRightInset
    }

    open func updateOnStateChange(state: PopButton.State) {
        switch state {
        case .normal:
            alpha = 1.0
        case .disabled:
            alpha = 0.6
        default:
            break
        }
    }
}

private extension PopButtonContainerView {
    func setup() {
        addSubview(stackView)

        stackViewLeadingConstraint = stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            stackViewLeadingConstraint,
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        stackView.addArrangedSubview(leftImageView)
        leftImageWidthConstraint = leftImageView.widthAnchor.constraint(equalToConstant: 20)
        leftImageWidthConstraint?.isActive = true

        stackView.addArrangedSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackView.addArrangedSubview(rightImageView)
        rightImageWidthConstraint = rightImageView.widthAnchor.constraint(equalToConstant: 20)
        rightImageWidthConstraint?.isActive = true
    }

    func updateLeftImage(withModel model: Model) {
        if let leftButtonImage = model.leftImage {
            setImage(leftButtonImage, forView: leftImageView, withTintColor: model.leftImageTintColor)
            leftImageView.isHidden = false
            leftImageWidthConstraint.constant = 20.0 * model.leftImageScale
        } else {
            leftImageView.isHidden = true
        }
    }

    func updateRightImage(withModel model: Model) {
        if let rightButtonImage = model.rightImage {
            setImage(rightButtonImage, forView: rightImageView, withTintColor: model.rightImageTintColor)
            rightImageView.isHidden = false
            rightImageWidthConstraint.constant = 20.0 * model.rightImageScale
        } else {
            rightImageView.isHidden = true
        }

    }

    func setImage(_ image: UIImage,
                  forView view: UIImageView,
                  withTintColor tintColor: UIColor?) {
        view.tintColor = tintColor
        view.image = image.withRenderingMode(tintColor == nil ? .alwaysOriginal : .alwaysTemplate)
    }
}
