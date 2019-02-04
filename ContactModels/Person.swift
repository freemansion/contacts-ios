//
//  Person.swift
//  ContactModels
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public struct Person: Codable {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let email: URL
    public let mobile: String
    public let profileImageURL: URL
    public let isFavorite: Bool
    public let createdAt: Date
    public let updatedAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case mobile = "phone_number"
        case profileImageURL = "profile_pic"
        case isFavorite = "favorite"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)

        // a hack to recover corrupted email data while parsing (made only for tha app demo purposes)
        let _email = try container.decode(String.self, forKey: .email)
        if _email.isEmpty {
            email = URL(string: "null@gmail.com")!
        } else {
            email = try container.decode(URL.self, forKey: .email)
        }

        mobile = try container.decode(String.self, forKey: .mobile)
        // a hack to recover corrupted avatar url while parsing (made only for tha app demo purposes)
        profileImageURL = try container.decodeIfPresent(URL.self, forKey: .profileImageURL) ?? URL(string: "/images/missing.png")!
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

public extension Person {
    init(id: Int, firstName: String, lastName: String, email: URL, mobile: String, profileImageURL: URL, favorite: Bool, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobile = mobile
        self.profileImageURL = profileImageURL
        self.isFavorite = favorite
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var fullName: String {
        return "\(firstName) \(lastName)".capitalized
    }
}
