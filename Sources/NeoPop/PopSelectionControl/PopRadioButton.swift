//
//  PopRadioButton.swift
//
//
//  Created by Somesh Karthik on 22/05/22.
//

import UIKit

/// This is standard `RadioButton` control, a subclass of ``PopSelectionControl``
///
/// It's appearance will change based on ``PopSelectionControl/mode-swift.property``
///
/// Incase of custom mode, It has two states which defines the custom user defines appearance from
/// 1. selected state
/// 2. unSelected state
///
/// It has a default ``PopSelectionControl/intrinsicContentSize``, so we can skip adding size constraints
///
/// Also the change in state can be observed by adding a target using `UIControl.EventvalueChanged`
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
