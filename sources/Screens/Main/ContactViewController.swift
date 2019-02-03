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
}

class ContactViewController: UIViewController, UIStoryboardIdentifiable {

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

extension ContactViewController: ContactScreenViewModelDelegate {
    func contactsScreenHandleEvent(_ event: ContactScreenEvent, viewModel: ContactScreenViewModelType) {
        switch event {
        case .setNeedReload:
            updateNavigationButtons()
        case .cancelAddNewContact:
            delegate?.contactViewDidTouchCancel(viewController: self, mode: screenViewModel.dataSource.state.initialMode)
        case .creatingNewContact:
            cancelButton.isEnabled = false
            navigationItem.rightBarButtonItem = .activityIndicatorButton
        case .didCreateNewContact:
            delegate?.contactViewDidCreateNewContact(viewController: self)
        }
    }
}
