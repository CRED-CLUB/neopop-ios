//
//  PopRadioButton.swift
//
//
//  Created by Somesh Karthik on 22/05/22.
//

import UIKit

open class PopRadioButton: PopSelectionControl {
    private let borderWidthDelta: CGFloat = 0.623

    override func getBorderWidth() -> CGFloat {
        if isSelectedState {
            return layer.bounds.height/2 * borderWidthDelta
        } else {
            return borderWidth
        }
    }

    override func getCornerRadius() -> CGFloat {
        return layer.bounds.height/2
    }

    override func getBackgroundColor() -> CGColor? {
        switch mode {
        case .light:
            return UIColor.white.cgColor
        case .dark:
            return UIColor.black.cgColor
        case let .custom(selectedModel, unSelectedModel):
            return isSelectedState ? selectedModel.backgroundColor.cgColor : unSelectedModel.backgroundColor.cgColor
        }
    }
}
