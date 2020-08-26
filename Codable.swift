//
//  Codable.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/26.
//

import Foundation

extension KeyedDecodingContainer {

    public func decodeWrapper<T>(key: K, defaultValue: T) throws -> T where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }

    public func decodeBool(_ key: Key) throws -> Bool {
        let boolString: String? = try decodeIfPresent(key)
        if let boolString = boolString, boolString.uppercased() == "TRUE" {
            return true
        }
        return false
    }

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
