//
//  Foundation.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

extension String {
    func trimWord(wordLimit: Int) -> String {
        let scanner = Scanner(string: self)
        var result: [String] = []
        if #available(iOS 13.0, *) {
            while let word = scanner.scanUpToCharacters(from: CharacterSet.whitespaces) {
                result.append(word)
                if result.count >= wordLimit {
                    break
                }
            }
        } else {
            var word: NSString?
            while scanner.scanUpToCharacters(from: CharacterSet.whitespaces, into: &word), let word = word as String? {
                result.append(word)
                if result.count >= wordLimit {
                    break
                }
            }
        }
        return result.joined(separator: " ")
    }
}
