//
//  Foundation.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

extension Double {
    public func fractionDigits(count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = count
        formatter.maximumFractionDigits = count
        return formatter.string(for: self) ?? "\(self)"
    }
}

extension String {
    public func trimWord(wordLimit: Int) -> String {
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

private extension String {
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
}

public extension String {
    
    /*
     let subText = "Hello World!"[1]
     print(subText)
     e
     */
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
}

public extension String {
    
    /*
     let range = NSRange(location: 0, length: 5)
     let subText = "Hello World!"[range]
     print(subText)
     Hello
     */
    subscript(value: NSRange) -> Substring {
        self[value.lowerBound..<value.upperBound]
    }
}

public extension String {
    
    /*
     let subText = "Hello World!"[0...5]
     print(subText)
     Hello
     */
    subscript(value: CountableClosedRange<Int>) -> Substring {
        self[index(at: value.lowerBound)...index(at: value.upperBound)]
    }
    
    /*
     let subText = "Hello World!"[0..<5]
     print(subText)
     Hello
     */
    subscript(value: CountableRange<Int>) -> Substring {
        self[index(at: value.lowerBound)..<index(at: value.upperBound)]
    }
    
    /*
     let subText = "Hello World!"[..<1]
     print(subText)
     H
     */
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(at: value.upperBound)]
    }
    
    /*
     let subText = "Hello World!"[...1]
     print(subText)
     He
     */
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        self[...index(at: value.upperBound)]
    }
    
    /*
     let subText = "Hello World!"[1...]
     print(subText)
     ello World!
     */
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        self[index(at: value.lowerBound)...]
    }
}

extension Dictionary where Key == String, Value == String {
    public var query: String? {
        var urlComponent = URLComponents(string: "")
        var queryItems: [URLQueryItem] = []
        for (key, value) in self {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponent?.queryItems = queryItems
        return urlComponent?.query
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension HTTPCookieStorage {
    public static func cookies(_ domain: String? = nil) -> [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies
        guard let domain = domain else { return cookies }
        
        let filteredCookies = cookies?.filter { ($0.domain as NSString).range(of: domain).location != NSNotFound }
        return filteredCookies
    }
    
    public static func deleteCookies(_ domain: String? = nil) {
        guard let cookies = self.cookies(domain) else { return }
        for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }
}
