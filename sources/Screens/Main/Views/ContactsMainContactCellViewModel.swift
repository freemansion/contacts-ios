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
        if !contact.profileImageURL.absoluteString.contains("http") {
            let baseURL = AppConfig.Constants.apiBaseURL
            return baseURL.appendingPathComponent(contact.profileImageURL.absoluteString)
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

}
