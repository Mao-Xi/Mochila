//
//  Foundation.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

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

extension Dictionary where Key == String, Value == String {
    var query: String? {
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
