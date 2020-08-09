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
    public static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = CONSTANT.enUSLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter
    }
    public static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = CONSTANT.enUSLocale
        dateFormatter.calendar = gregorianCalendar
        return dateFormatter
    }
    public static let standardUserDefault = UserDefaults.standard
}

extension Sequence where Iterator.Element: Hashable {
    public func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
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
