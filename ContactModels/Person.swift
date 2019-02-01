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
    public let profileImageURL: URL
    public let isFavorite: Bool
    public let createdAt: Date
    public let updatedAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case profileImageURL = "profile_pic"
        case isFavorite = "favorite"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public extension Person {
    init(id: Int, firstName: String, lastName: String, email: URL, profileImageURL: URL, favorite: Bool, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profileImageURL = profileImageURL
        self.isFavorite = favorite
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var fullName: String {
        return "\(firstName) \(lastName)".capitalized
    }
}
