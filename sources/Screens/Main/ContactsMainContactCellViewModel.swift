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
    let placeholderIcon: UIImage

    init(contact: ContactsListPerson, placeholderIcon: UIImage) {
        self.contact = contact
        self.placeholderIcon = placeholderIcon
    }

    var avatarURL: URL? {
        let baseURL = AppConfig.Constants.apiBaseURL
        return baseURL.appendingPathComponent(contact.profileImageURL.absoluteString)
    }

    var fullName: String {
        return contact.fullName
    }

    var isFavorite: Bool {
        return contact.isFavorite
    }

}
