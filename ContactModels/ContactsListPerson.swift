//
//  Person.swift
//  ContactModels
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public struct ContactsListPerson: Codable {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let profileImageURL: URL
    public let isFavorite: Bool
    public let fullInfoURL: URL

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImageURL = "profile_pic"
        case isFavorite = "favorite"
        case fullInfoURL = "url"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        // a hack to recover corrupted data while parsing (made only for tha app demo purposes)
        profileImageURL = try container.decodeIfPresent(URL.self, forKey: .profileImageURL) ?? URL(string: "/images/missing.png")!
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        fullInfoURL = try container.decode(URL.self, forKey: .fullInfoURL)
    }
}

public extension ContactsListPerson {
    init(id: Int, firstName: String, lastName: String, profileImageURL: URL, favorite: Bool, fullInfoURL: URL) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageURL = profileImageURL
        self.isFavorite = favorite
        self.fullInfoURL = fullInfoURL
    }

    var fullName: String {
        return "\(firstName) \(lastName)".capitalized
    }
}
