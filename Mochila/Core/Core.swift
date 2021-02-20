//
//  Core.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

public struct CONSTANT {
    public static let screenWidth = UIScreen.main.bounds.width
    public static let screenHeight = UIScreen.main.bounds.height
    public static var lineWidth = 1 / UIScreen.main.scale
    public static let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    public static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    public static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    public static let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    public static let isSimulator = TARGET_OS_SIMULATOR == 1
    public static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    public static let gregorianCalendar = Calendar(identifier: .gregorian)
    public static let enUSLocale = Locale(identifier: "en_US")
    public static let standardUserDefault = UserDefaults.standard
}

extension Sequence where Iterator.Element: Hashable {
    public func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public func + <K, V> (left: [K:V], right: [K:V]) -> [K:V] {
    var result: [K:V] = [:]
    for (k, v) in left {
        result[k] = v
    }
    for (k, v) in right {
        result[k] = v
    }
    return result
}

public func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

public func swizzle(type: AnyClass, original originalSelector: Selector, swizzled swizzledSelector: Selector) {
    #if swift(>=4.0)
    guard let originalMethod = class_getInstanceMethod(type, originalSelector),
        let swizzledMethod = class_getInstanceMethod(type, swizzledSelector)
        else { return }
    #else
    let originalMethod = class_getInstanceMethod(type, originalSelector)
    let swizzledMethod = class_getInstanceMethod(type, swizzledSelector)
    #endif

    // Check whether original method has been swizzlled
    if class_addMethod(
        type, originalSelector,
        method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod)
        ) {
        class_replaceMethod(
            type, swizzledSelector, originalMethod,
            method_getTypeEncoding(originalMethod)
        )
    } else {
        method_exchangeImplementations(
            originalMethod,
            swizzledMethod
        )
    }
}

public func objc_getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, defaultValue: T) -> T {
    guard let value = objc_getAssociatedObject(object, key) as? T else {
        return defaultValue
    }
    return value
}

public protocol SelfAware: class {
    static func awake()
}

extension UIApplication {

    private static let runOnce: Void = {
        UIButton.awake()
    }()

    open override var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}
