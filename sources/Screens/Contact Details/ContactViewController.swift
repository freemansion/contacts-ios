//
//  ContactViewController.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ContactViewControllerDelegate: class {
    func contactViewDidTouchCancel(viewController: ContactViewController, mode: ContactScreenViewModel.Mode)
    func contactViewDidCreateNewContact(viewController: ContactViewController)
    func contactViewFailedToLoadContact(viewController: ContactViewController)
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
        case .didCreateNewContact:
            delegate?.contactViewDidCreateNewContact(viewController: self)
        case .loadingContact(let isLoading):
            collectionView.reloadData()
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = !isLoading }
        case .didReceiveAnError(.loadingData(let errorMessage)):
            presentErrorAlert(message: errorMessage, animated: true, handler: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.contactViewFailedToLoadContact(viewController: self)
            })
        case .didReceiveAnError(.createContact(let errorMessage)):
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

}

extension ContactViewController: ContactFieldCellDelegate {

}

extension ContactViewController: ConfirmationAlertPresentable {}
