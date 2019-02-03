//
//  ContactViewController.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

enum ContactChange {
    case create(id: Int)
    case update(id: Int)
    case delete(id: Int)
}

protocol ContactViewControllerDelegate: class {
    func contactViewDidTouchCancel(viewController: ContactViewController, mode: ContactScreenViewModel.Mode)
    func contactViewFailedToLoadContact(viewController: ContactViewController)
    func contactViewDidUpdateContact(change: ContactChange, viewController: ContactViewController)
}

class ContactViewController: UIViewController, UIStoryboardIdentifiable {

    @IBOutlet private weak var collectionView: UICollectionView!
    weak var delegate: ContactViewControllerDelegate?
    private var screenViewModel: ContactScreenViewModelType!
    private var mode: ContactScreenViewModel.Mode {
        return screenViewModel.dataSource.state.mode
    }

    private lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(title: R.string.localizable.contacts_details_navigation_cancel(), style: .plain, target: self, action: #selector(didTouchCancelButton(_:)))
    }()

    private lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(title: R.string.localizable.contacts_details_navigation_done(), style: .done, target: self, action: #selector(didTouchDoneButton(_:)))
    }()

    private lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(title: R.string.localizable.contacts_details_navigation_edit(), style: .plain, target: self, action: #selector(didTouchEditButton(_:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenViewModel.actions.viewWillAppear()
    }

    private func configureView() {
        navigationController?.makeWhiteNavigationBar()
        updateNavigationButtons()
        configureCollectionView()
    }

    static func makeInstance(mode: ContactScreenViewModel.Mode) -> ContactViewController {
        let viewModel = ContactScreenViewModel(mode: mode)
        let vc = Storyboard.Main.instantiate(viewControllerType: ContactViewController.self)
        viewModel.delegate = vc
        vc.screenViewModel = viewModel
        return vc
    }

    func updateNavigationButtons() {
        let leftBarButtons = navigationItem.leftBarButtonItems ?? []

        switch mode {
        case .addNew, .edit:
            navigationItem.leftBarButtonItems = leftBarButtons + [cancelButton]
            navigationItem.rightBarButtonItems = [doneButton]
        case .view:
            navigationItem.leftBarButtonItems = leftBarButtons.filter { $0 != cancelButton }
            navigationItem.rightBarButtonItems = [editButton]
        }
    }

}

extension ContactViewController {
    // MARK: actions
    @objc private func didTouchCancelButton(_ sender: Any) {
        screenViewModel.actions.didTouchCancel()
    }

    @objc private func didTouchDoneButton(_ sender: Any) {
        view.endEditing(true)
        screenViewModel.actions.didTouchDone()
    }

    @objc private func didTouchEditButton(_ sender: Any) {
        screenViewModel.actions.didTouchEdit()
    }
}

extension ContactViewController: ContactScreenViewModelDelegate, ErrorAlertPresentable {
    func contactsScreenHandleEvent(_ event: ContactScreenEvent, viewModel: ContactScreenViewModelType) {
        switch event {
        case .setNeedReload:
            collectionView.reloadData()
            updateNavigationButtons()
        case .cancelAddNewContact:
            delegate?.contactViewDidTouchCancel(viewController: self, mode: screenViewModel.dataSource.state.initialMode)
        case .creatingNewContact:
            cancelButton.isEnabled = false
            navigationItem.rightBarButtonItem = .activityIndicatorButton
        case .updatingOrLoadingContact(let loading):
            cancelButton.isEnabled = !loading
            if loading {
                navigationItem.rightBarButtonItem = .activityIndicatorButton
            } else {
                updateNavigationButtons()
            }
        case .didCreateNewContact(let id):
            delegate?.contactViewDidUpdateContact(change: .create(id: id), viewController: self)
        case .didUpdateContact(let id):
            delegate?.contactViewDidUpdateContact(change: .update(id: id), viewController: self)
        case .didDeleteContact(let id):
            delegate?.contactViewDidUpdateContact(change: .delete(id: id), viewController: self)
        case .setBusy(let busy):
            collectionView.reloadData()
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = !busy }
        case .didReceiveAnError(.loadingData(let errorMessage)):
            presentErrorAlert(message: errorMessage, animated: true, handler: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.contactViewFailedToLoadContact(viewController: self)
            })
        case .didReceiveAnError(.createContact(let errorMessage)):
            presentErrorAlert(message: errorMessage)
        case .didReceiveAnError(.updateContact(let errorMessage)):
            cancelButton.isEnabled = true
            updateNavigationButtons()
            presentErrorAlert(message: errorMessage)
        case .didReceiveAnError(.deleteContact(let errorMessage)):
            presentErrorAlert(message: errorMessage)
        }
    }
}

extension ContactViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(R.nib.contactProfilePreviewCell)
        collectionView.register(R.nib.contactFieldCell)
        collectionView.register(R.nib.contactActionCell)
        collectionView.register(R.nib.contactLoadingCell)
        collectionView.register(R.nib.genericCollectionViewCell)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return screenViewModel.dataSource.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = screenViewModel.dataSource.item(for: indexPath)
        let boundingSize = collectionView.bounds.size

        switch item {
        case .loadingContact(let viewModel):
            return ContactLoadingCell.size(for: viewModel, boundingSize: boundingSize)
        case .verticalSpace(let height):
            return GenericCollectionViewCell.size(forWidth: boundingSize.width, itemType: .space, preferredHeight: height)

        case .preview(.profileHeader(let viewModel)):
            return ContactProfilePreviewCell.size(for: viewModel, boundingSize: boundingSize)
        case .preview(.mobilePhone(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .preview(.email(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .preview(.deleteContact(let viewModel)):
            return ContactActionCell.size(for: viewModel, boundingSize: boundingSize)

        case .edit(.profileHeader(let viewModel)):
            return ContactProfilePreviewCell.size(for: viewModel, boundingSize: boundingSize)
        case .edit(.firstName(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .edit(.lastName(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .edit(.mobilePhone(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .edit(.email(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)

        case .addNew(.profileHeader(let viewModel)):
            return ContactProfilePreviewCell.size(for: viewModel, boundingSize: boundingSize)
        case .addNew(.firstName(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .addNew(.lastName(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .addNew(.mobilePhone(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        case .addNew(.email(let viewModel)):
            return ContactFieldCell.size(for: viewModel, boundingSize: boundingSize)
        }
    }

    // swiftlint:disable function_body_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = screenViewModel.dataSource.item(for: indexPath)

        switch item {
        case .loadingContact(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactLoadingCell, for: indexPath)!
            cell.configure(with: viewModel)
            return cell

        case .verticalSpace:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.genericCollectionViewCell, for: indexPath)!
            cell.configure(as: .space)
            return cell

        case .preview(.profileHeader(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactProfilePreviewCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .preview(.mobilePhone(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .preview(.email(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .preview(.deleteContact(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactActionCell, for: indexPath)!
            cell.configure(with: viewModel)
            return cell

        case .edit(.profileHeader(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactProfilePreviewCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .edit(.firstName(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .edit(.lastName(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .edit(.mobilePhone(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .edit(.email(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell

        case .addNew(.profileHeader(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactProfilePreviewCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell

        case .addNew(.firstName(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .addNew(.lastName(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .addNew(.mobilePhone(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        case .addNew(.email(let viewModel)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.contactFieldCell, for: indexPath)!
            cell.configure(with: viewModel, delegate: self)
            return cell
        }
    }
    // swiftlint:enable function_body_length

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = screenViewModel.dataSource.item(for: indexPath)

        switch item {
        case .preview(.deleteContact):
            let deleteContact: ((UIAlertAction) -> Void) = { [weak self] _ in
                guard let self = self else { return }
                self.screenViewModel.actions.deleteContact()
            }

            presentConfirmationAlert(message: R.string.localizable.contacts_details_delete_alert_title(),
                                     animated: true,
                                     confirmationTitle: R.string.localizable.contacts_details_delete_title(),
                                     confirmationStyle: .destructive,
                                     handler: deleteContact)
        default:
            return
        }
    }
}

extension ContactViewController: ContactProfilePreviewCellDelegate {
    func contactProfileDidReceiveAction(_ action: ContactProfileAction, cell: ContactProfilePreviewCell) {
        switch action {
        case .camera:
            presentImagePicker()
        case .message, .call, .email, .favorite:
            screenViewModel.actions.handleAction(action)
        }
    }
}

extension ContactViewController: ContactFieldCellDelegate {
    func contactFieldValueChanged(_ value: String?, cell: ContactFieldCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let item = screenViewModel.dataSource.item(for: indexPath)
        switch item {
        case .addNew(.firstName):
            screenViewModel.actions.didEditField(.firstName, value: value)
        case .addNew(.lastName):
            screenViewModel.actions.didEditField(.lastName, value: value)
        case .addNew(.mobilePhone):
            screenViewModel.actions.didEditField(.mobile, value: value)
        case .addNew(.email):
            screenViewModel.actions.didEditField(.email, value: value)
        case .edit(.firstName):
            screenViewModel.actions.didEditField(.firstName, value: value)
        case .edit(.lastName):
            screenViewModel.actions.didEditField(.lastName, value: value)
        case .edit(.mobilePhone):
            screenViewModel.actions.didEditField(.mobile, value: value)
        case .edit(.email):
            screenViewModel.actions.didEditField(.email, value: value)
        default:
            return
        }
    }
}

extension ContactViewController: ConfirmationAlertPresentable {}

extension ContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        screenViewModel.actions.didPickAnAvatarPicture(image)
    }

    private func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
}
