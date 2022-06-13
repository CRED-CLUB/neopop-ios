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
        static var NeoViewPopDataHolderAssociationKey: UInt8 = 0
    }

    private var neoPopViewDataHolder: PopViewHolder? {
        get { return objc_getAssociatedObject(self, &NeoPopAssociatedKeys.NeoViewPopDataHolderAssociationKey) as? PopViewHolder }
        set { objc_setAssociatedObject(self, &NeoPopAssociatedKeys.NeoViewPopDataHolderAssociationKey, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    func applyNeoPopStyle(model: PopView.Model) {

        layer.masksToBounds = false
        backgroundColor = .clear

        // if the self is `PopView`, then we don't need to create a `PopViewHolder`. we can directly update the view model
        if let popView = self as? PopView {
            popView.configurePopView(withModel: model)
            return
        }

        if let neoPopViewDataHolder = neoPopViewDataHolder {
            neoPopViewDataHolder.popView?.configurePopView(withModel: model)
        } else {
            let neoPopView = PopView(frame: bounds, model: model)
            neoPopViewDataHolder = PopViewHolder(view: neoPopView)
        }

        if let neoPopView = neoPopViewDataHolder?.popView, !neoPopView.isDescendant(of: self) {
            addSubview(neoPopView)
            neoPopView.fillSuperview()
            sendSubviewToBack(neoPopView)
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
