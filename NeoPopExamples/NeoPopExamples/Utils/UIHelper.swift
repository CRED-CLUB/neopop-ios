//
//  UIHelper.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 13/06/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit

final class UIHelper {
    static func getContainerViewFor(text: String,
                                    button: UIButton,
                                    buttonHeight: CGFloat,
                                    spacing: CGFloat = 10) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill

        let imageView = UIImageView(image: UIImage(named: text)!)
        imageView.contentMode = .scaleAspectFit

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(button)

        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true

        return stackView
    }
}
