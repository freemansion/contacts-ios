//
//  ContactMobilePhoneCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ContactFieldCellDelegate: class {
    func contactFieldValueChanged(_ value: String?, cell: ContactFieldCell)
}

class ContactFieldCell: UICollectionViewCell {

    private enum Constants {
        static let contentHeight: CGFloat = 56
    }

    typealias Dependencies = HasKeyboardManager
    private let dependencies: Dependencies = AppDependencies.shared

    @IBOutlet private weak var fieldDescriptionLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    weak var delegate: ContactFieldCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textValueChanged(_:)), for: .editingChanged)
    }

    func configure(with viewModel: ContactFieldCellViewModel, delegate: ContactFieldCellDelegate? = nil) {
        self.delegate = delegate
        fieldDescriptionLabel.text = viewModel.fieldDescription
        textField.text = viewModel.fieldValue
        textField.returnKeyType = viewModel.returnKeyType ?? .next
        textField.isUserInteractionEnabled = viewModel.editingAllowed
    }

    static func size(for viewModel: ContactFieldCellViewModel, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width, height: Constants.contentHeight)
    }

}

extension ContactFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            switch textField.returnKeyType {
            case .next where dependencies.appKeyboardManager.canGoNext:
                dependencies.appKeyboardManager.goNext()
            case .done:
                textField.resignFirstResponder()
            default:
                break
            }
        }
        return true
    }

    @objc private func textValueChanged(_ sender: Any) {
        delegate?.contactFieldValueChanged(textField.text, cell: self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.contactFieldValueChanged(textField.text, cell: self)
    }
}
