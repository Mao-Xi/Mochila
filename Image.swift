//
//  Image.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

private var _bitmapInfo: UInt32 = {
    var bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue
    bitmapInfo &= ~CGBitmapInfo.alphaInfoMask.rawValue
    bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue
    return bitmapInfo
}()

extension CGImage {
    public func op(_ closure: (CGContext?, CGRect) -> ()) -> CGImage? {
        let width = self.width
        let height = self.height
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 8, space: colourSpace, bitmapInfo: bitmapInfo.rawValue)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        closure(context, rect)
        return context!.makeImage()
    }

    public static func op(_ width: Int, _ height: Int, closure: (CGContext?) -> ()) -> CGImage? {
        let scale = UIScreen.main.scale
        let w = width * Int(scale)
        let h = height * Int(scale)
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 8, space: colourSpace, bitmapInfo: _bitmapInfo)
        context!.translateBy(x: 0, y: CGFloat(h))
        context!.scaleBy(x: scale, y: -scale)
        closure(context)
        return context!.makeImage()
    }

    public func blend(_ mode: CGBlendMode, color: CGColor, alpha: CGFloat = 1) -> CGImage? {
        return op { context, rect in
            context!.setFillColor(color)
            context!.fill(rect)
            context!.setBlendMode(mode)
            context!.setAlpha(alpha)
            context!.draw(self, in: rect)
        }
    }

    public static func create(_ color: CGColor, size: CGSize) -> CGImage? {
        return op(Int(size.width), Int(size.height)) { (context) in
            let rect = CGRect(origin: .zero, size: size)
            context!.setFillColor(color)
            context!.fill(rect)
        }
    }
}

extension UIImage {
    public func blend(_ color: UIColor) -> UIImage? {
        return blend(CGBlendMode.destinationIn, color: color)
    }

    public func blend(_ mode: CGBlendMode, color: UIColor, alpha: CGFloat = 1) -> UIImage? {
        if let cgImage = cgImage?.blend(mode, color: color.cgColor, alpha: alpha) {
            let image = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
            return image
        }
        return nil
    }

    public convenience init?(fromColor: UIColor) {
        if let cgImage = CGImage.create(fromColor.cgColor, size: CGSize(width: 1, height: 1)) {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
