//
//  ContactActionCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactActionCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    private enum Constants {
        static let contentHeight: CGFloat = 44
    }

    func configure(with viewModel: ContactActionCellViewModel) {
        titleLabel.text = viewModel.actionTitle
    }

    static func size(for viewModel: ContactActionCellViewModel, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width, height: Constants.contentHeight)
    }

}
