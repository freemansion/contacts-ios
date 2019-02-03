//
//  ContactProfilePreviewCellViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit
import ContactModels

struct ContactProfilePreviewCellViewModel {
    let contact: Person
    let isUpdatingFavorite: Bool

    var avatarURL: URL {
        return contact.profileImageURL
    }

    var fullName: String {
        return contact.fullName
    }

    var isFavorite: Bool {
        return contact.isFavorite
    }
}
