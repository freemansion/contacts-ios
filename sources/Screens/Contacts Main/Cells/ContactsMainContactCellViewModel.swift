//
//  ContactsMainContactCellViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import UIKit
import ContactModels

struct ContactsMainContactCellViewModel {
    private let contact: ContactsListPerson
    let groupName: String
    let placeholderIcon: UIImage

    init(groupName: String, contact: ContactsListPerson, placeholderIcon: UIImage) {
        self.groupName = groupName
        self.contact = contact
        self.placeholderIcon = placeholderIcon
    }

    var avatarURL: URL? {
        // Note: hack, as fetched url format is not consistent
        let urlString = contact.profileImageURL.absoluteString
        if urlString == "/images/missing.png" {
            return nil
        } else if !urlString.contains("http") {
            let baseURL = AppConfig.Constants.apiBaseURL
            return baseURL.appendingPathComponent(urlString)
        } else {
            return contact.profileImageURL
        }
    }

    var fullName: String {
        return contact.fullName
    }

    var isFavorite: Bool {
        return contact.isFavorite
    }

    var contactId: Int {
        return contact.id
    }

}
