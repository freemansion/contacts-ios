//
//  ContactLoadingCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactLoadingCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    func configure(with viewModel: ContactLoadingCellViewModel) {
        titleLabel.text = viewModel.title
        if viewModel.isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    static func size(for viewModel: ContactLoadingCellViewModel, boundingSize size: CGSize) -> CGSize {
        return size
    }

}
