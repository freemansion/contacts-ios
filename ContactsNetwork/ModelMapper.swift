//
//  ModelMapper¸.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public enum ParseError: LocalizedError {
    case typeMismatch

    public var localizedDescription: String {
        switch self {
        case .typeMismatch: return "Type is not matching to expected."
        }
    }
}

public struct ModelMapper {
    public static let `default` = ModelMapper()

    private func _decodeJson<T: Decodable>(type: T.Type, from json: [String: Any], decoder: JSONDecoder) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decoder.decode(T.self, from: data)
    }

    private func _decodeJson<T: Decodable>(type: T.Type, from json: [[String: Any]], decoder: JSONDecoder) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decoder.decode(T.self, from: data)
    }

    public func map<T>(_ type: T.Type, from json: [String: Any], decoder: JSONDecoder = JSONDecoder(), atKeyPath keyPath: String? = nil) throws -> T where T: Decodable {
        if let _keyPath = keyPath, let keyPathJson = json[_keyPath] as? [String: Any] {
            return try _decodeJson(type: type, from: keyPathJson, decoder: decoder)
        } else if let _keyPath = keyPath, let keyPathJson = json[_keyPath] as? [[String: Any]] {
            return try _decodeJson(type: type, from: keyPathJson, decoder: decoder)
        } else {
            return try _decodeJson(type: type, from: json, decoder: decoder)
        }
    }

    public func map<T>(_ type: T.Type, from json: Any, decoder: JSONDecoder = JSONDecoder(), atKeyPath keyPath: String? = nil) throws -> T where T: Decodable {
        if let _json = json as? [String: Any] {
            return try _decodeJson(type: type, from: _json, decoder: decoder)
        } else if let _json = json as? [[String: Any]] {
            return try _decodeJson(type: type, from: _json, decoder: decoder)
        } else {
            throw ParseError.typeMismatch
        }
    }
}
