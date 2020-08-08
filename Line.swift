//
//  Line.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

private var topLineKey: Void?

extension UIView {

    static func autoLayoutView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    @IBInspectable var topLineEnabled: Bool {
        get {
            if let _ = objc_getAssociatedObject(self, &topLineKey) as? UIView {
                return true
            }
            return false
        }
        set(value) {
            if let view = objc_getAssociatedObject(self, &topLineKey) as? UIView {
                view.removeFromSuperview()
            }
            if !value { return }

            let view = UIView.autoLayoutView()
            view.backgroundColor = borderColor
            addSubview(view)

            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: CONSTANT.lineWidth).isActive = true

            objc_setAssociatedObject(self, &topLineKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}