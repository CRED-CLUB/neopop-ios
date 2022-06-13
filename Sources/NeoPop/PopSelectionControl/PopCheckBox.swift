//
//  PopCheckBox.swift
//
//
//  Created by Somesh Karthik on 22/05/22.
//

import UIKit

open class PopCheckBox: PopSelectionControl {

    override func getBorderWidth() -> CGFloat {
        borderWidth
    }

    override func getBackgroundColor() -> CGColor? {
        switch mode {
        case .light:
            return isSelectedState ? UIColor.black.cgColor : UIColor.white.cgColor
        case .dark:
            return isSelectedState ? UIColor.white.cgColor : UIColor.black.cgColor
        case let .custom(selectedModel, unSelectedModel):
            return isSelectedState ? selectedModel.backgroundColor.cgColor : unSelectedModel.backgroundColor.cgColor
        }
    }

    override func getImage() -> CGImage? {
        switch mode {
        case .dark:
            return isSelectedState ? getDarkTickImage().cgImage : nil
        case .light:
            return isSelectedState ? getLightTickImage().cgImage : nil
        case let .custom(selectedModel, unSelectedModel):
            let selectedImage = selectedModel.image
            let unselectedImage = unSelectedModel.image
            return isSelectedState ? selectedImage?.cgImage : unselectedImage?.cgImage
        }
    }
}
