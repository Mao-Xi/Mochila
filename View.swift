//
//  View.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

extension UIButton {

    convenience init(logo: UIImage, text: String, font: UIFont, textColor: UIColor, action: Selector) {
        self.init()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = logo
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 11)
        let attributedTitle = NSMutableAttributedString(attachment: imageAttachment)
        let attributedText = NSAttributedString(string: " \(text)", attributes: [.font: font, .foregroundColor: textColor])
        attributedTitle.append(attributedText)
        setAttributedTitle(attributedTitle, for: .normal)
        addTarget(self, action: action, for: .touchUpInside)
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
    
    public func setImageAndTitleVerticalAlignmentCenter(spacing: CGFloat, imageSize: CGSize) {
        if imageSize == CGSize.zero { return }
        guard let titleLabel = titleLabel, let text = titleLabel.text else { return }
        let titleSize = text.size(withAttributes: [NSAttributedString.Key.font: titleLabel.font!])
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
    }
    
    public func setImageAndTitleHorizontalAlignmentCenter(spacing: CGFloat, titleInRight: Bool = true) {
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        if !titleInRight {
            transform = CGAffineTransform(scaleX: -1, y: 1)
            titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    public func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.1
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        layer.add(flash, forKey: nil)
    }
}

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
