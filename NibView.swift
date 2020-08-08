//
//  NibView.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

private var viewKey: Void?

public protocol NibViewProtocol {
    func replaceFirstChildView(nibName: String) -> UIView
}

extension NibViewProtocol where Self: UIView {
    public func replaceFirstChildView(nibName: String) -> UIView {
        if let view = objc_getAssociatedObject(self, &viewKey) as? UIView {
            view.removeFromSuperview()
        }

        let buddle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: buddle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        insertSubview(view, at: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        objc_setAssociatedObject(self, &viewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return view
    }
}

open class NibView: UIView, NibViewProtocol {
    open var nibName: String { return String(describing: type(of: self)) }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    @IBOutlet var lineWidth: [NSLayoutConstraint]!

    open func setup() {
        _ = replaceFirstChildView(nibName: nibName)
        if lineWidth != nil {
            for c in lineWidth {
                c.constant = CONSTANT.lineWidth
            }
        }
    }
}
