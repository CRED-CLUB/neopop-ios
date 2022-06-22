//
//  PopButton+ModelGenerator.swift
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

extension PopButton {

    ///
    /// Custom insets has a great role in controlling the visibility of the button's center part.
    /// while drawing few positions the button face will be partially visible in order to show the 3D effect that it has went inside.
    /// So these insets will be used for that.
    ///
    func customInsets() -> UIEdgeInsets {
        return drawingManager.buttonCustomInsets(buttonModel: model)
    }

    ///
    /// This method returns the model for highlighted state of the button
    /// w.r.t to the `direction` of the button and the `position` of the button this model values differs.
    ///
    /// we decide the
    /// 1. ``PopView/Model/customEdgeVisibility``
    /// 2. ``PopView/Model/customBorderVisibility``
    /// 3. ``PopView/Model/verticalEdgeColor``
    /// 4. ``PopView/Model/horizontalEdgeColor``
    /// 5. ``PopView/Model/verticalBorderColors``
    /// 6. ``PopView/Model/horizontalBorderColors``
    /// and whether to clip the edge etc.
    ///
    func getHighlightedModel() -> PopView.Model {

        // whether clip any edge on he head OR tail.
        var clipEdgeToOffsetWidth: EdgeClipping = .none
        var clipEdgeToOffsetHeight: EdgeClipping = .none

        // visibility of the edge.
        var customEdgeVisibility: EdgeVisibilityModel?
        var customBorderVisibility: EdgeVisibilityModel?

        // color of the superview of the NeoView holding the button.
        let parentContainerBGColor = model.parentContainerBGColor ?? .clear

        // color of the NeoView holding the button.
        let superViewBGColor = model.superViewColor ?? .clear

        // Vertical and horizontal edge colors.
        var verticalEdgeColor: UIColor = PopHelper.verticalEdgeColor(for: superViewBGColor)
        var horizontalEdgeColor: UIColor = PopHelper.horizontalEdgeColor(for: superViewBGColor)

        // direction of the pressed state model
        let direction = normalStateEdgeDirection.selectedDirection

        // In the use case of, whether an adjacent button is available, some of the sides which aren't available needs to be shown in some positions.
        // which is controlled by these params.
        let reverseBottomEdgeVisibility: Bool = model.adjacentButtonAvailability?.bottom ?? false
        let reverseTopEdgeVisibility: Bool = model.adjacentButtonAvailability?.top ?? false
        let reverseRightEdgeVisibility: Bool = model.adjacentButtonAvailability?.right ?? false
        let reverseLeftEdgeVisibility: Bool = model.adjacentButtonAvailability?.left ?? false

        // Border colors
        var verticalEdgeBorderColor: EdgeColors?
        var horizontalEdgeBorderColor: EdgeColors?

        let position = model.position

        // Show/Hide edges
        var hideBottomEdge = false
        var hideTopEdge = false
        var hideRightEdge = false
        var hideLeftEdge = false
        /*
         for hiding the edges of the highlighted model, we need to see the positions of the button (not on edges where super view is visible) after which we can consider whether to hide the edge or not.
         */

        switch direction { // Selection direction
        case .topLeft:

            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            // This is common config for topLeft
            hideBottomEdge = false
            hideTopEdge = reverseTopEdgeVisibility
            hideRightEdge = false
            hideLeftEdge = reverseLeftEdgeVisibility

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

            switch position {

            case .bottomRight:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .bottomEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .bottomLeft:
                clipEdgeToOffsetWidth = .clipDistantCorners
                verticalEdgeColor = parentContainerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .leftEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                verticalEdgeColor = parentContainerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .topLeft:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                verticalEdgeColor = parentContainerBGColor
                horizontalEdgeColor = parentContainerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .topEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                horizontalEdgeColor = parentContainerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .topRight:
                clipEdgeToOffsetHeight = .clipDistantCorners
                horizontalEdgeColor = parentContainerBGColor
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .rightEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .center:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            }

        case .topRight:

            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            // This is common config for topRight
            hideBottomEdge = false
            hideTopEdge = reverseTopEdgeVisibility
            hideRightEdge = reverseRightEdgeVisibility
            hideLeftEdge = false

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

            switch position {

            case .bottomLeft:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .bottomRight:
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .bottomEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .leftEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topLeft:
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topEdge:
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topRight:
                horizontalEdgeColor = parentContainerBGColor
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: true, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .rightEdge:
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .center:
                clipEdgeToOffsetHeight = .clipDistantCorners
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            }

        case .bottomLeft:

            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            // This is common config for bottomLeft
            hideBottomEdge = reverseBottomEdgeVisibility
            hideTopEdge = false
            hideRightEdge = false
            hideLeftEdge = reverseLeftEdgeVisibility

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            switch position {
            case .topRight:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .topEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .topLeft:
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .leftEdge:
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .bottomLeft:
                verticalEdgeColor = parentContainerBGColor
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: true, hideCenterPath: true)

            case .bottomEdge:
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .bottomRight:
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .rightEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

            case .center:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: false, hideLeftEdge: hideLeftEdge, hideCenterPath: true)
            }

        case .bottomRight:

            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            // This is common config for topleft
            hideBottomEdge = reverseBottomEdgeVisibility
            hideTopEdge = false
            hideRightEdge = reverseRightEdgeVisibility
            hideLeftEdge = false

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            switch position {
            case .topLeft:
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topEdge:
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .topRight:
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .rightEdge:
                verticalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .bottomRight:
                verticalEdgeColor = parentContainerBGColor
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: true, hideLeftEdge: false, hideCenterPath: true)

            case .bottomEdge:
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .bottomLeft:
                horizontalEdgeColor = parentContainerBGColor
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: true, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)

            case .leftEdge:
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)
            case .center:
                clipEdgeToOffsetWidth = .clipDistantCorners
                clipEdgeToOffsetHeight = .clipDistantCorners
                customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: false, hideRightEdge: hideRightEdge, hideLeftEdge: false, hideCenterPath: true)
            }

        case .top:
            // This is common config for Top
            hideBottomEdge = false
            hideTopEdge =  true
            hideRightEdge = false
            hideLeftEdge = false

            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: false, hideTopEdge: hideTopEdge, hideRightEdge: false, hideLeftEdge: false, hideCenterPath: true)

        case .bottom:
            // This is common config for Bottom
            hideBottomEdge = true
            hideTopEdge =  false
            hideRightEdge = false
            hideLeftEdge = false

            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        case .right:
            hideBottomEdge = false
            hideTopEdge =  false
            hideRightEdge = true
            hideLeftEdge = false

            horizontalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        case .left:
            hideBottomEdge = false
            hideTopEdge =  false
            hideRightEdge = false
            hideLeftEdge = true

            horizontalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor

            customBorderVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        }

        customEdgeVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        return PopView.Model(popEdgeDirection: direction, customEdgeVisibility: customEdgeVisibility, customBorderVisibility: customBorderVisibility, edgeOffSet: edgePadding, backgroundColor: .clear, verticalEdgeColor: verticalEdgeColor, horizontalEdgeColor: horizontalEdgeColor, verticalBorderColors: verticalEdgeBorderColor, horizontalBorderColors: horizontalEdgeBorderColor, clipsToOffSetWidth: clipEdgeToOffsetWidth, clipsToOffSetHeight: clipEdgeToOffsetHeight, borderWidth: model.borderWidth)
    }

    ///
    /// This method returns the model for normal state of the button
    /// w.r.t to the direction of the button and the position of the button this model values differs.
    ///
    func getNormalModel(forDisabledState disabled: Bool = false) -> PopView.Model {

        var clipEdgeToOffsetWidth: EdgeClipping = .none
        var clipEdgeToOffsetHeight: EdgeClipping = .none

        var customEdgeVisibility: EdgeVisibilityModel?
        let customBorderVisibility: EdgeVisibilityModel? = nil

        let buttonBGColor = disabled.transformed(true: ColorHelper.disabledBGColor, false: model.backgroundColor)
        let showStaticEdge: Bool = disabled.transformed(true: false, false: model.showStaticBaseEdges)

        var verticalEdgeColor: UIColor = PopHelper.verticalEdgeColor(for: buttonBGColor)
        var horizontalEdgeColor: UIColor = PopHelper.horizontalEdgeColor(for: buttonBGColor)

        let reverseBottomEdgeVisibility: Bool = model.adjacentButtonAvailability?.bottom ?? false
        let reverseTopEdgeVisibility: Bool = model.adjacentButtonAvailability?.top ?? false
        let reverseRightEdgeVisibility: Bool = model.adjacentButtonAvailability?.right ?? false
        let reverseLeftEdgeVisibility: Bool = model.adjacentButtonAvailability?.left ?? false

        var verticalEdgeBorderColor: EdgeColors?
        var horizontalEdgeBorderColor: EdgeColors?

        let position = model.position
        var hideBottomEdge = false
        var hideTopEdge = false
        var hideRightEdge = false
        var hideLeftEdge = false

        switch normalStateEdgeDirection {
        case .bottomRight:
            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.bottom, verticalEdgeBorderColor?.right)
                verticalEdgeBorderColor?.right = nil
                horizontalEdgeBorderColor?.bottom = nil
            }

            switch position {
            case .bottomRight:
                hideBottomEdge = reverseBottomEdgeVisibility
                hideRightEdge = reverseRightEdgeVisibility

            case .bottomEdge, .bottomLeft:
                hideBottomEdge = reverseBottomEdgeVisibility
                hideRightEdge = !reverseRightEdgeVisibility

            case .leftEdge, .topLeft, .topEdge:
                hideBottomEdge = !reverseBottomEdgeVisibility
                hideRightEdge = !reverseRightEdgeVisibility
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .topRight, .rightEdge:
                hideBottomEdge = !reverseBottomEdgeVisibility
                hideRightEdge = reverseRightEdgeVisibility

            case .center:
                hideBottomEdge = !reverseBottomEdgeVisibility
                hideRightEdge = !reverseRightEdgeVisibility

            }

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

        case .bottomLeft:
            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.bottom, verticalEdgeBorderColor?.left)
                verticalEdgeBorderColor?.left = nil
                horizontalEdgeBorderColor?.bottom = nil
            }

            switch position {
            case .bottomLeft:
                hideBottomEdge = reverseBottomEdgeVisibility
                hideLeftEdge = reverseLeftEdgeVisibility

            case .bottomEdge, .bottomRight:
                hideBottomEdge = reverseBottomEdgeVisibility
                hideLeftEdge = !reverseLeftEdgeVisibility

            case .rightEdge, .topRight, .topEdge:
                hideBottomEdge = !reverseBottomEdgeVisibility
                hideLeftEdge = !reverseLeftEdgeVisibility
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .topLeft, .leftEdge:
                hideBottomEdge = !reverseBottomEdgeVisibility
                hideLeftEdge = reverseLeftEdgeVisibility

            case .center:
                hideBottomEdge = !reverseBottomEdgeVisibility
                hideLeftEdge = !reverseLeftEdgeVisibility

            }

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

        case .topRight:
            verticalEdgeBorderColor = neoButtonBorderColor?.rightEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.top, verticalEdgeBorderColor?.right)
                verticalEdgeBorderColor?.right = nil
                horizontalEdgeBorderColor?.top = nil
            }

            switch position {
            case .topRight:
                hideTopEdge = reverseTopEdgeVisibility
                hideRightEdge = reverseRightEdgeVisibility

            case .topEdge, .topLeft:
                hideTopEdge = reverseTopEdgeVisibility
                hideRightEdge = !reverseRightEdgeVisibility

            case .leftEdge, .bottomLeft, .bottomEdge:
                hideTopEdge = !reverseTopEdgeVisibility
                hideRightEdge = !reverseRightEdgeVisibility
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .bottomRight, .rightEdge:
                hideTopEdge = !reverseTopEdgeVisibility
                hideRightEdge = reverseRightEdgeVisibility

            case .center:
                hideTopEdge = !reverseTopEdgeVisibility
                hideRightEdge = !reverseRightEdgeVisibility

            }

            verticalEdgeColor = customEdgeColor?.right ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

        case .topLeft:
            verticalEdgeBorderColor = neoButtonBorderColor?.leftEdgeBorder
            horizontalEdgeBorderColor = neoButtonBorderColor?.topEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.top, verticalEdgeBorderColor?.left)
                verticalEdgeBorderColor?.left = nil
                horizontalEdgeBorderColor?.top = nil
            }

            switch position {
            case .topLeft:
                hideTopEdge = reverseTopEdgeVisibility
                hideLeftEdge = reverseLeftEdgeVisibility

            case .topEdge, .topRight:
                hideTopEdge = reverseTopEdgeVisibility
                hideLeftEdge = !reverseLeftEdgeVisibility

            case .rightEdge, .bottomRight, .bottomEdge:
                hideTopEdge = !reverseTopEdgeVisibility
                hideLeftEdge = !reverseLeftEdgeVisibility
                clipEdgeToOffsetWidth = .clipJoinedCorners
                clipEdgeToOffsetHeight = .clipJoinedCorners

            case .bottomLeft, .leftEdge:
                hideTopEdge = !reverseTopEdgeVisibility
                hideLeftEdge = reverseLeftEdgeVisibility

            case .center:
                hideTopEdge = !reverseTopEdgeVisibility
                hideLeftEdge = !reverseLeftEdgeVisibility

            }

            verticalEdgeColor = customEdgeColor?.left ?? verticalEdgeColor
            horizontalEdgeColor = customEdgeColor?.top ?? horizontalEdgeColor

        case .bottom:
            hideBottomEdge = reverseBottomEdgeVisibility
            horizontalEdgeColor = customEdgeColor?.bottom ?? horizontalEdgeColor

            horizontalEdgeBorderColor = neoButtonBorderColor?.bottomEdgeBorder

            if showStaticEdge {
                staticBorderColors = (horizontalEdgeBorderColor?.bottom, nil)
                horizontalEdgeBorderColor?.bottom = nil
            }

        default:
            break
        }

        // No border for disabled state.
        verticalEdgeBorderColor = disabled.transformed(true: nil, false: verticalEdgeBorderColor)
        horizontalEdgeBorderColor = disabled.transformed(true: nil, false: horizontalEdgeBorderColor)

        customEdgeVisibility = EdgeVisibilityModel(hideBottomEdge: hideBottomEdge, hideTopEdge: hideTopEdge, hideRightEdge: hideRightEdge, hideLeftEdge: hideLeftEdge, hideCenterPath: true)

        return PopView.Model(popEdgeDirection: normalStateEdgeDirection, customEdgeVisibility: customEdgeVisibility, customBorderVisibility: customBorderVisibility, edgeOffSet: edgePadding, backgroundColor: .clear, verticalEdgeColor: verticalEdgeColor, horizontalEdgeColor: horizontalEdgeColor, verticalBorderColors: verticalEdgeBorderColor, horizontalBorderColors: horizontalEdgeBorderColor, clipsToOffSetWidth: clipEdgeToOffsetWidth, clipsToOffSetHeight: clipEdgeToOffsetHeight, delegate: nil, modelIdentifier: "btn_normal_state_model", borderWidth: model.borderWidth)

    }
}
