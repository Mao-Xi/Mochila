//
//  View.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

extension UIStackView {
    @discardableResult
    public func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }
    
    public func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}

extension UIBarButtonItem {
    @IBInspectable var original: Bool {
        get {
            return image?.renderingMode == .alwaysOriginal
        }
        set(original) {
            image = image?.withRenderingMode(original ? .alwaysOriginal : .alwaysTemplate)
        }
    }
}
