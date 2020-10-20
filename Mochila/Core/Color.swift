//
//  Color.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

extension UIColor {
    public convenience init(hexRGB hex: UInt, alpha: CGFloat = 1) {
        let ff: CGFloat = 255.0;
        let r = CGFloat((hex & 0xff0000) >> 16) / ff
        let g = CGFloat((hex & 0xff00) >> 8) / ff
        let b = CGFloat(hex & 0xff) / ff
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    public func overlay(_ color: UIColor) -> UIColor {
        var ra: CGFloat = 0, ga: CGFloat = 0, ba: CGFloat = 0, aa: CGFloat = 0
        var rb: CGFloat = 0, gb: CGFloat = 0, bb: CGFloat = 0, ab: CGFloat = 0
        color.getRed(&ra, green: &ga, blue: &ba, alpha: &aa)
        func blend(_ b: CGFloat, _ a: CGFloat) -> CGFloat {
            if a < 0.5 {
                return 2 * a * b
            } else {
                return 1 - 2 * (1 - a) * (1 - b)
            }
        }
        getRed(&rb, green: &gb, blue: &bb, alpha: &ab)
        let r = blend(ra, rb)
        let g = blend(ga, gb)
        let b = blend(ba, bb)
        let a = blend(aa, ab)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

public func +(lhs: UIColor, rhs: UIColor) -> UIColor {
    return lhs.overlay(rhs)
}
