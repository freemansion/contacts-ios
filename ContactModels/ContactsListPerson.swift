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
