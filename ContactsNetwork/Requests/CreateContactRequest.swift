//
//  CreateContactRequest.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/4/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public struct CreateContactRequest: RequestDataProvidable {

    public let firstName: String
    public let lastName: String
    public let email: String
    public let mobile: String
    public let profileImageURLString: String?

    public init(firstName: String, lastName: String, email: String, mobile: String, profileImageURLString: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobile = mobile
        self.profileImageURLString = profileImageURLString
    }

    var endpoint: String {
        return "/contacts.json"
    }

    public var bodyParameters: [String: Any] {
        var params: [String: Any] = ["first_name": firstName,
                                     "last_name": lastName,
                                     "email": email,
                                     "phone_number": mobile]
        if let value = profileImageURLString {
            params["profile_pic"] = value
        }
        return params
    }

}
