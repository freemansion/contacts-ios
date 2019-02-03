//
//  ContactFieldCellViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import UIKit

struct ContactFieldCellViewModel {
    let fieldDescription: String
    let fieldValue: String?
    let editingAllowed: Bool
    let returnKeyType: UIReturnKeyType?

    init(fieldDescription: String, fieldValue: String?, editingAllowed: Bool = false, returnKeyType: UIReturnKeyType? = nil) {
        self.fieldDescription = fieldDescription
        self.fieldValue = fieldValue
        self.editingAllowed = editingAllowed
        self.returnKeyType = returnKeyType
    }
}
