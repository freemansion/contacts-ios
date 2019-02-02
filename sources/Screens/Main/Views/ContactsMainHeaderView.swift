//
//  ContactsMainHeaderView.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactsMainHeaderView: UITableViewHeaderFooterView {
    static let nib = UINib(nibName: R.nib.contactsMainHeaderView.name, bundle: R.nib.contactsMainHeaderView.bundle)
    static let reuseIdentifier = R.nib.contactsMainHeaderView.name
    static let height: CGFloat = 28

    @IBOutlet weak var titleLabel: UILabel!
}
