//
//  UIView+PopView.swift
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

public extension UIView {
    private struct NeoPopAssociatedKeys {
        static var dataHolder: UInt8 = 0
    }

    private var popViewDataHolder: PopViewHolder? {
        get { return objc_getAssociatedObject(self, &NeoPopAssociatedKeys.dataHolder) as? PopViewHolder }
        set { objc_setAssociatedObject(self, &NeoPopAssociatedKeys.dataHolder, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    /// Use this method to apply NeoPop style to any ``UIView``
    ///
    /// refer ``PopView/Model`` for all the list of properties which are configurable
    ///
    /// ```swift
    /// let model = PopView.Model(
    ///     popEdgeDirection: .bottomRight,
    ///     edgeOffSet: 10,
    ///     backgroundColor: UIColor.white
    /// )
    ///
    /// someUIView.applyNeoPopStyle(model: model)
    /// ```
    ///
    /// - Parameter model: model which configures the appearance of ``PopView``
    ///
    func applyNeoPopStyle(model: PopView.Model) {

        layer.masksToBounds = false
        backgroundColor = .clear

        // if the self is `PopView`, then we don't need to create a `PopViewHolder`. we can directly update the view model
        if let popView = self as? PopView {
            popView.configurePopView(withModel: model)
            return
        }

        if let popViewDataHolder = popViewDataHolder {
            popViewDataHolder.popView?.configurePopView(withModel: model)
        } else {
            let popView = PopView(frame: bounds, model: model)
            popViewDataHolder = PopViewHolder(view: popView)
        }

        if let popView = popViewDataHolder?.popView, !popView.isDescendant(of: self) {
            addSubview(popView)
            popView.fillSuperview()
            sendSubviewToBack(popView)
        }
    }
}

private class PopViewHolder: NSObject, NSCopying {

    fileprivate var popView: PopView?

    required init(view: PopView) {
        self.popView = view
    }

    required init(_ objectToCopy: PopViewHolder) {
        self.popView = objectToCopy.popView
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(self)
    }
}
