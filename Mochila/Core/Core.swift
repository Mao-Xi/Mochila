//
//  Core.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

struct CONSTANT {
    static var lineWidth = 1 / UIScreen.main.scale
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

func + <K, V> (left: [K:V], right: [K:V]) -> [K:V] {
    var result: [K:V] = [:]
    for (k, v) in left {
        result[k] = v
    }
    for (k, v) in right {
        result[k] = v
    }
    return result
}

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
