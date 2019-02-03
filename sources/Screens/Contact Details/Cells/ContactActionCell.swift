//
//  ContactActionCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ContactActionCellDelegate: class {

}

class ContactActionCell: UICollectionViewCell {

    private enum Constants {
        static let contentHeight: CGFloat = 44
    }

    weak var delegate: ContactActionCellDelegate?

    func configure(with viewModel: ContactActionCellViewModel, delegate: ContactActionCellDelegate? = nil) {
        self.delegate = delegate
    }

    static func size(for viewModel: ContactActionCellViewModel, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width, height: Constants.contentHeight)
    }

}
