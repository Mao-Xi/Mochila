//
//  Button.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/31.
//

import UIKit

extension UIButton: SelfAware {

    public enum ButtonLayout : Int {

        case none = 0
        case imageInLeft
        case imageInRight
        case imageInTop
        case imageInBottom
    }

    private struct AssociatedKeys {
        static var usingMaxMarginKey: UInt8 = 0
        static var spaceKey: UInt8 = 0
        static var buttonLayoutKey: UInt8 = 0
    }

    // Default is false. if true, space will be ignored
    @IBInspectable var usingMaxMargin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.usingMaxMarginKey, defaultValue: false)
        }
        set(newValue) {
            if usingMaxMargin == newValue { return }
            objc_setAssociatedObject(self, &AssociatedKeys.usingMaxMarginKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
        }
    }

    @IBInspectable var space: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.spaceKey, defaultValue: 0)
        }
        set(newValue) {
            if space == newValue { return }
            objc_setAssociatedObject(self, &AssociatedKeys.spaceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
        }
    }

    public var buttonLayout: ButtonLayout {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.buttonLayoutKey, defaultValue: .none)
        }
        set(newValue) {
            if buttonLayout == newValue { return }
            objc_setAssociatedObject(self, &AssociatedKeys.buttonLayoutKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
        }
    }

    @IBInspectable var buttonLayoutAdapter: Int {
        get {
            return buttonLayout.rawValue
        }
        set(newValue) {
            buttonLayout = ButtonLayout(rawValue: newValue) ?? .none
        }
    }

    public func reloadLayout(_ layout: ButtonLayout, _ space: CGFloat, _ usingMaxMargin: Bool = false) {
        self.buttonLayout = layout
        self.space = space
        self.usingMaxMargin = usingMaxMargin
    }

    public static func awake() {
        swizzle(type: UIButton.self, original: #selector(UIButton.layoutSubviews), swizzled: #selector(UIButton.swizzledLayoutSubviews))
        swizzle(type: UIButton.self, original: #selector(getter: UIButton.intrinsicContentSize), swizzled: #selector(getter: UIButton.swizzledIntrinsicContentSize))
    }

    @objc func swizzledLayoutSubviews() {
        self.swizzledLayoutSubviews()
        if let _ = imageView?.image, buttonLayout != .none {
            switch buttonLayout {
            case .imageInLeft:
                layoutSubviewsWithImageInLeft()
            case .imageInRight:
                layoutSubviewsWithImageInRight()
            case .imageInTop:
                layoutSubviewsWithImageInTop()
            case .imageInBottom:
                layoutSubviewsWithImageInBottom()
            default:
                break
            }
        }
    }

    private func layoutSubviewsWithImageInLeft() {
        guard let imageSize = imageView?.image?.size, let title = titleLabel?.text, let font = titleLabel?.font else { return }

        let buttonWidth = frame.size.width
        let buttonHeight = frame.size.height

        let maxTextWidth = buttonWidth - imageSize.width - space
        let labelSize = font.sizeOfString(string: title, constrainedToWidth: maxTextWidth, constrainedToHeight: buttonHeight)

        var padding = space
        if usingMaxMargin {
            padding = buttonWidth - labelSize.width - imageSize.width - contentEdgeInsets.left - contentEdgeInsets.right
        }

        let imageViewX = (buttonWidth - labelSize.width - imageSize.width - padding) / 2.0
        let imageViewY = (buttonHeight - imageSize.height) / 2.0
        imageView?.frame = CGRect(x: imageViewX, y: imageViewY, width: imageSize.width, height: imageSize.height)

        let labelX = imageViewX + imageSize.width + padding
        let labelY = (buttonHeight - labelSize.height) / 2.0
        titleLabel?.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
    }

    private func layoutSubviewsWithImageInRight() {
        guard let imageSize = imageView?.image?.size, let title = titleLabel?.text, let font = titleLabel?.font else { return }

        let buttonWidth = frame.size.width
        let buttonHeight = frame.size.height

        let maxTextWidth = buttonWidth - imageSize.width - space
        let labelSize = font.sizeOfString(string: title, constrainedToWidth: maxTextWidth, constrainedToHeight: buttonHeight)

        var padding = space
        if usingMaxMargin {
            padding = buttonWidth - labelSize.width - imageSize.width - contentEdgeInsets.left - contentEdgeInsets.right
        }

        let labelX = (buttonWidth - labelSize.width - imageSize.width - padding) / 2.0
        let labelY = (buttonHeight - labelSize.height) / 2.0
        titleLabel?.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)

        let imageViewX = labelX + labelSize.width + padding
        let imageViewY = (buttonHeight - imageSize.height) / 2.0
        imageView?.frame = CGRect(x: imageViewX, y: imageViewY, width: imageSize.width, height: imageSize.height)
    }

    private func layoutSubviewsWithImageInTop() {
        guard let imageSize = imageView?.image?.size, let title = titleLabel?.text, let font = titleLabel?.font else { return }

        let buttonWidth = frame.size.width
        let buttonHeight = frame.size.height

        let maxTextHeight = buttonHeight - imageSize.height - space
        let labelSize = font.sizeOfString(string: title, constrainedToWidth: buttonWidth, constrainedToHeight: maxTextHeight)

        var padding = space
        if usingMaxMargin {
            padding = buttonHeight - labelSize.height - imageSize.height - contentEdgeInsets.top - contentEdgeInsets.bottom
        }

        let imageViewX = (buttonWidth - imageSize.width) / 2.0
        let imageViewY = (buttonHeight - labelSize.height - imageSize.height - padding) / 2.0
        imageView?.frame = CGRect(x: imageViewX, y: imageViewY, width: imageSize.width, height: imageSize.height)

        let labelX = (buttonWidth - labelSize.width) / 2.0
        let labelY = imageViewY + imageSize.height + padding
        titleLabel?.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
    }

    private func layoutSubviewsWithImageInBottom() {
        guard let imageSize = imageView?.image?.size, let title = titleLabel?.text, let font = titleLabel?.font else { return }

        let buttonWidth = frame.size.width
        let buttonHeight = frame.size.height

        let maxTextHeight = buttonHeight - imageSize.height - space
        let labelSize = font.sizeOfString(string: title, constrainedToWidth: buttonWidth, constrainedToHeight: maxTextHeight)

        var padding = space
        if usingMaxMargin {
            padding = buttonHeight - labelSize.height - imageSize.height - contentEdgeInsets.top - contentEdgeInsets.bottom
        }

        let labelX = (buttonWidth - labelSize.width) / 2.0
        let labelY = (buttonHeight - labelSize.height - imageSize.height - padding) / 2.0
        titleLabel?.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)

        let imageViewX = (buttonWidth - imageSize.width) / 2.0
        let imageViewY = labelY + labelSize.height + padding
        imageView?.frame = CGRect(x: imageViewX, y: imageViewY, width: imageSize.width, height: imageSize.height)
    }

    @objc private var swizzledIntrinsicContentSize: CGSize {
        var size: CGSize!
        if let imageRect = imageView?.frame {
            if let labelRect = titleLabel?.frame {
                size = imageRect.union(labelRect).size
            } else {
                size = imageRect.size
            }
        } else if let labelRect = titleLabel?.frame {
            size = labelRect.size
        } else {
            size = .zero
        }

        size.width += (contentEdgeInsets.left + contentEdgeInsets.right)
        size.height += (contentEdgeInsets.top + contentEdgeInsets.bottom)
        return size
    }

    public func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
