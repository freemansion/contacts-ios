//
//  ContactProfilePreviewCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

enum ContactProfileAction {
    case message, call, email, favorite
}

protocol ContactProfilePreviewCellDelegate: class {
    func contactProfileDidReceiveAction(_ action: ContactProfileAction, cell: ContactProfilePreviewCell)
}

class ContactProfilePreviewCell: UICollectionViewCell {

    private enum Constants {
        static let contentHeight: CGFloat = 269
        static let avatarPlaceholder = R.image.person_placeholder()!
    }

    @IBOutlet private weak var avatarImageView: DesignableImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var messageButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var callButton: UIButton!
    @IBOutlet private weak var callLabel: UILabel!
    @IBOutlet private weak var emailButton: UIButton!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var favoriteLabel: UILabel!
    @IBOutlet private weak var favouriteProgressIndicator: UIActivityIndicatorView!

    weak var delegate: ContactProfilePreviewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.text = R.string.localizable.contacts_details_profile_header_message_title()
        callLabel.text = R.string.localizable.contacts_details_profile_header_call_title()
        emailLabel.text = R.string.localizable.contacts_details_profile_header_email_title()
        favoriteLabel.text = R.string.localizable.contacts_details_profile_header_favorite_title()
        favouriteProgressIndicator.isHidden = true
    }

    func configure(with viewModel: ContactProfilePreviewCellViewModel, delegate: ContactProfilePreviewCellDelegate? = nil) {
        self.delegate = delegate

        ImageLoader.default.loadImage(url: viewModel.avatarURL,
                                      options: .imageLoadingOptions(placeholder: Constants.avatarPlaceholder),
                                      into: avatarImageView)
        fullNameLabel.text = viewModel.fullName
        favoriteButton.isSelected = viewModel.isFavorite
        favouriteProgressIndicator.isHidden = !viewModel.isUpdatingFavorite
        favoriteButton.isEnabled = !viewModel.isUpdatingFavorite
        if viewModel.isUpdatingFavorite {
            favouriteProgressIndicator.startAnimating()
        } else {
            favouriteProgressIndicator.stopAnimating()
        }
    }

    @IBAction func messageButtonAction(_ sender: Any) {
        delegate?.contactProfileDidReceiveAction(.message, cell: self)
    }

    @IBAction func callButtonAction(_ sender: Any) {
        delegate?.contactProfileDidReceiveAction(.call, cell: self)
    }

    @IBAction func emailButtonAction(_ sender: Any) {
        delegate?.contactProfileDidReceiveAction(.email, cell: self)
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        delegate?.contactProfileDidReceiveAction(.favorite, cell: self)
    }

    static func size(for viewModel: ContactProfilePreviewCellViewModel, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width, height: Constants.contentHeight)
    }

}
