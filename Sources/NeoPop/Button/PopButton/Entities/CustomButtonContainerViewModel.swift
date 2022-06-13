//
//  CustomButtonContainerViewModel.swift
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

public extension CustomButtonContainerView {
    struct Model {
        public var title: String?
        public var attributedTitle: NSAttributedString?
        public var leftImage: UIImage?
        public var leftImageTintColor: UIColor?
        public var rightImage: UIImage?
        public var rightImageTintColor: UIColor?

        public var leftImageScale: CGFloat = 1.0
        public var rightImageScale: CGFloat = 1.0

        public var contentLeftRightInset: CGFloat = 20

        public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, leftImage: UIImage? = nil, leftImageTintColor: UIColor? = nil, rightImage: UIImage? = nil, rightImageTintColor: UIColor? = nil, leftImageScale: CGFloat = 1.0, rightImageScale: CGFloat = 1.0, contentLeftRightInset: CGFloat = 20) {
            self.title = title
            self.attributedTitle = attributedTitle
            self.leftImage = leftImage
            self.leftImageTintColor = leftImageTintColor
            self.rightImage = rightImage
            self.rightImageTintColor = rightImageTintColor
            self.leftImageScale = leftImageScale
            self.rightImageScale = rightImageScale
            self.contentLeftRightInset = contentLeftRightInset
        }
    }

}
