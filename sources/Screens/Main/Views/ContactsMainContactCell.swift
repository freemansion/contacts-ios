//
//  ContactsMainContactCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactsMainContactCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var contactNameLabel: UILabel!
    @IBOutlet private weak var favoriteIcon: UIImageView!

    enum Constants {
        static let contentHeight: CGFloat = 64
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.masksToBounds = true
        contactNameLabel.textColor = UIColor.Theme.greyishBrown
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    func configure(with viewModel: ContactsMainContactCellViewModel) {
        ImageLoader.default.loadImage(url: viewModel.avatarURL,
                                  options: .imageLoadingOptions(placeholder: viewModel.placeholderIcon),
                                     into: avatarImageView)
        contactNameLabel.text = viewModel.fullName
        favoriteIcon.isHidden = viewModel.isFavorite
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
}
