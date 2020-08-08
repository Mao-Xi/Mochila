//
//  Layout.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

public extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get { if let color = layer.borderColor { return UIColor(cgColor: color) } else { return nil } }
        set(value) { if let value = value { layer.borderColor = value.cgColor } }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set(value) { layer.borderWidth = value }
    }
    
    @IBInspectable var relativeBorderWidth: CGFloat {
        get { return layer.borderWidth * UIScreen.main.scale }
        set(value) { layer.borderWidth = value / UIScreen.main.scale }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set(value) { layer.cornerRadius = value }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set(value) { layer.masksToBounds = value }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { if let color = layer.shadowColor { return UIColor(cgColor: color) } else { return nil } }
        set(value) { if let value = value { layer.shadowColor = value.cgColor } }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        get { return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height) }
        set(value) { layer.shadowOffset = CGSize(width: value.x, height: value.y) }
    }
    
    @IBInspectable var relativeShadowOffset: CGPoint {
        get { return CGPoint(x: layer.shadowOffset.width * UIScreen.main.scale, y: layer.shadowOffset.height * UIScreen.main.scale) }
        set(value) { layer.shadowOffset = CGSize(width: value.x / UIScreen.main.scale, height: value.y / UIScreen.main.scale) }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set(value) {
            layer.shadowOpacity = value
            layer.masksToBounds = false
            if value > 0 {
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
            } else {
                layer.shouldRasterize = false
            }
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set(value) { layer.shadowRadius = value }
    }
    
    @IBInspectable var relativeShadowRadius: CGFloat {
        get { return layer.shadowRadius * UIScreen.main.scale }
        set(value) { layer.shadowRadius = value / UIScreen.main.scale }
    }
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func noCornerMask() {
        layer.mask = nil
    }
}

extension UIStoryboardSegue {
    public func topViewController<T>() -> T? {
        var dest: T? = nil
        if let controller = destination as? T {
            dest = controller
        } else {
            if let controller = destination as? UINavigationController {
                if let controller = controller.topViewController as? T {
                    dest = controller
                }
            }
        }
        return dest
    }
}

extension UIDevice {
    public static var hasNotch: Bool {
        return safeAreaBottomHeight > 0
    }
    
    public static var safeAreaTopHeight: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }
    
    public static var safeAreaBottomHeight: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}
