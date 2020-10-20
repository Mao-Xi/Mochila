//
//  Number.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/31.
//

import Foundation

extension Formatter {

    public static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = CONSTANT.enUSLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter
    }()
}

extension Double {
    
    public func fractionDigits(count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = count
        formatter.maximumFractionDigits = count
        return formatter.string(for: self) ?? "\(self)"
    }
}
