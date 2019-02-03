//
//  ContactProfilePreviewCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ContactProfilePreviewCellDelegate: class {

}

class ContactProfilePreviewCell: UICollectionViewCell {

    private enum Constants {
        static let contentHeight: CGFloat = 269
    }

    weak var delegate: ContactProfilePreviewCellDelegate?

    func configure(with viewModel: ContactProfilePreviewCellViewModel, delegate: ContactProfilePreviewCellDelegate? = nil) {
        self.delegate = delegate
    }

    static func size(for viewModel: ContactProfilePreviewCellViewModel, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width, height: Constants.contentHeight)
    }

}
