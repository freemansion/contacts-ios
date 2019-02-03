//
//  UpdateContactDetailsRequest.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public struct UpdateContactDetailsRequest: RequestDataProvidable {

    public let contactId: Int
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let mobile: String?
    public let profileImageURLString: String?
    public let isFavorite: Bool?

    public init(contactId: Int, firstName: String?, lastName: String?, email: String?, mobile: String?, profileImageURLString: String?, isFavorite: Bool?) {
        self.contactId = contactId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobile = mobile
        self.profileImageURLString = profileImageURLString
        self.isFavorite = isFavorite
    }

    var endpoint: String {
        return "/contacts/\(contactId).json"
    }

    public var bodyParameters: [String: Any] {
        var params: [String: Any] = [:]
        if let value = firstName {
            params["first_name"] = value
        }
        if let value = lastName {
            params["last_name"] = value
        }
        if let value = email {
            params["email"] = value
        }
        if let value = mobile {
            params["phone_number"] = value
        }
        if let value = profileImageURLString {
            params["profile_pic"] = value
        }
        if let value = isFavorite {
            params["favorite"] = value
        }
        return params
    }

}
