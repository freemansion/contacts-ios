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
    enum State {
        case add, view, edit
    }

    let contact: Person?
    let isUpdatingFavorite: Bool
    let isUploadingImage: Bool
    let state: State
    let avatarImage: UIImage?

    init(contact: Person? = nil, isUpdatingFavorite: Bool, isUploadingImage: Bool = false, state: State, avatarImage: UIImage? = nil) {
        self.contact = contact
        self.isUpdatingFavorite = isUpdatingFavorite
        self.isUploadingImage = isUploadingImage
        self.state = state
        self.avatarImage = avatarImage
    }

    var avatarURL: URL? {
        guard let url = contact?.profileImageURL,
            url.absoluteString != "/images/missing.png" else {
                return nil
        }
        return contact?.profileImageURL
    }

    var fullName: String? {
        return contact?.fullName
    }

    var isFavorite: Bool {
        return contact?.isFavorite ?? false
    }
}
