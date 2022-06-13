//
//  PopViewDrawable.swift
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

public protocol PopViewDrawable: AnyObject {

    // Customise the drawings for the vertical/horizontal edges and the center layer.
    func getPathForCenterContentLayer(view: UIView?, frame: CGRect, model: PopView.Model, borderPoints: inout CustomBorderDrawingPoints) -> UIBezierPath?
    func getPathForVerticalLayer(view: UIView?, frame: CGRect, model: PopView.Model, borderPoints: inout CustomBorderDrawingPoints) -> UIBezierPath?
    func getPathForHorizontalLayer(view: UIView?, frame: CGRect, model: PopView.Model, borderPoints: inout CustomBorderDrawingPoints) -> UIBezierPath?
}

public extension PopViewDrawable {
    func getPathForCenterContentLayer(view: UIView?, frame: CGRect, model: PopView) -> UIBezierPath? {
        return nil
    }

    func getPathForVerticalLayer(view: UIView?, frame: CGRect, model: PopView, borderPoints: inout CustomBorderDrawingPoints) -> UIBezierPath? {
        return nil
    }

    func getPathForHorizontalLayer(view: UIView?, frame: CGRect, model: PopView, borderPoints: inout CustomBorderDrawingPoints) -> UIBezierPath? {
        return nil
    }
}
