//
//  ContactsMainLoadingCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactsMainLoadingCell: UITableViewCell {  
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    func configure(with viewModel: ContactsMainLoadingCellViewModel) {
        titleLabel.text = viewModel.title
        if viewModel.isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    static func size(forBoundingSize size: CGSize) -> CGSize {
        return size
    }
}
