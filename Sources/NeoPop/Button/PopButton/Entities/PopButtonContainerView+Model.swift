//
//  PopButtonContainerView+Model.swift
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

public extension PopButtonContainerView {

    /// Use this model to define the button content in ``PopButton`` and ``PopFloatingButton``
    struct Model {

        /// It is used to configure the title of the button
        ///
        /// refer ``PopButtonContainerView/Model/attributedTitle`` for configuring title through `NSAttributedString`
        ///
        public var title: String?

        /// It is used to configure the title of the button
        ///
        /// refer ``PopButtonContainerView/Model/title`` for configuring title through `String`
        ///
        public var attributedTitle: NSAttributedString?

        /// It is added to the left side of the label
        ///
        /// If the value is nil, then the image will be hidden
        public var leftImage: UIImage?

        /// It is used to tint the ``PopButtonContainerView/Model/leftImage``
        ///
        /// If the value is nil, default color of the image will be rendered
        ///
        public var leftImageTintColor: UIColor?

        /// It is added to the right side of the label
        ///
        /// If the value is nil, then the image will be hidden
        public var rightImage: UIImage?

        /// It is used to tint the ``PopButtonContainerView/Model/rightImage``
        ///
        /// If the value is nil, default color of the image will be rendered
        ///
        public var rightImageTintColor: UIColor?

        /// It is used to scale the ``PopButtonContainerView/Model/leftImage``
        ///
        /// By Default. ``PopButtonContainerView/Model/leftImage`` will have `height` as `20`.
        /// So we can use this value to update the aspectRatio
        ///
        /// Default value is `1.0`
        public var leftImageScale: CGFloat = 1.0

        /// It is used to scale the ``PopButtonContainerView/Model/rightImage``
        ///
        /// By Default. ``PopButtonContainerView/Model/rightImage`` will have `height` as `20`.
        /// So we can use this value to update the aspectRatio
        ///
        /// Default value is `1.0`
        public var rightImageScale: CGFloat = 1.0

        /// It is used to add some padding in leading and trailing of the button content.
        ///
        /// Since the button content is always center aligned in the horizontal direction.
        /// we cannot have different leading and trailing padding. So this property applies equal padding
        /// in leading and trailing
        ///
        /// Default value is `20`
        public var contentLeftRightInset: CGFloat = 20

        public init(title: String?,
                    leftImage: UIImage? = nil,
                    leftImageTintColor: UIColor? = nil,
                    rightImage: UIImage? = nil,
                    rightImageTintColor: UIColor? = nil,
                    leftImageScale: CGFloat = 1.0,
                    rightImageScale: CGFloat = 1.0,
                    contentLeftRightInset: CGFloat = 20) {
            self.title = title
            self.leftImage = leftImage
            self.leftImageTintColor = leftImageTintColor
            self.rightImage = rightImage
            self.rightImageTintColor = rightImageTintColor
            self.leftImageScale = leftImageScale
            self.rightImageScale = rightImageScale
            self.contentLeftRightInset = contentLeftRightInset
        }
        
        public init(attributedTitle: NSAttributedString?,
                    leftImage: UIImage? = nil,
                    leftImageTintColor: UIColor? = nil,
                    rightImage: UIImage? = nil,
                    rightImageTintColor: UIColor? = nil,
                    leftImageScale: CGFloat = 1.0,
                    rightImageScale: CGFloat = 1.0,
                    contentLeftRightInset: CGFloat = 20) {
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
