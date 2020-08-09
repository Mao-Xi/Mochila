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

extension KeyedDecodingContainer {
    public func decodeDecimal(_ key: Key) throws -> Decimal {
        let decimalString: String? = try decodeIfPresent(key)
        if let decimalString = decimalString, let decimal = Decimal(string: decimalString) {
            return decimal
        }
        return 0
    }
    
    public func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try decode(T.self, forKey: key)
    }
    
    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
    
    public func decodeSafely<T: Decodable>(_ key: KeyedDecodingContainer.Key) -> T? {
        return self.decodeSafely(T.self, forKey: key)
    }
    
    public func decodeSafely<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        let decoded = try? decode(Safe<T>.self, forKey: key)
        return decoded?.value
    }
    
    public func decodeSafelyIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) -> T? {
        return self.decodeSafelyIfPresent(T.self, forKey: key)
    }
    
    public func decodeSafelyIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        let decoded = try? decodeIfPresent(Safe<T>.self, forKey: key)
        return decoded?.value
    }
}

public struct Id<Entity>: Hashable {
    public let raw: String
    
    public init(_ raw: String) {
        self.raw = raw
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(raw.hashValue)
    }
    
    public var hashValue: Int {
        return raw.hashValue
    }
    
    public static func ==(lhs: Id, rhs: Id) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension Id: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if raw.isEmpty {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Id cannot be empty string")
        }
        self.init(raw)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }
}

public enum Parameter<Base: Swift.Codable>: Swift.Encodable {
    case null
    case value(Base)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null: try container.encodeNil()
        case let .value(value): try container.encode(value)
        }
    }
}

public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            assertionFailure("ERROR: \(error)")
            print(error)
            self.value = nil
        }
    }
}
