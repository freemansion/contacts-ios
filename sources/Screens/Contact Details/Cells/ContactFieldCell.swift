//
//  ContactMobilePhoneCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ContactFieldCellDelegate: class {

}

class ContactFieldCell: UICollectionViewCell {

    private enum Constants {
        static let contentHeight: CGFloat = 56
    }

    weak var delegate: ContactFieldCellDelegate?

    func configure(with viewModel: ContactFieldCellViewModel, delegate: ContactFieldCellDelegate? = nil) {
        self.delegate = delegate
    }

    static func size(for viewModel: ContactFieldCellViewModel, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width, height: Constants.contentHeight)
    }

}
