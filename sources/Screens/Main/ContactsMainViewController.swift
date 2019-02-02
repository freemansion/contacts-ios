//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactsMainViewController: UIViewController, UIStoryboardIdentifiable {

    @IBOutlet private weak var groupsBarButton: UIBarButtonItem!
    @IBOutlet private weak var addBarButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    private lazy var screenViewModel: ContactsMainScreenViewModelType = {
        let viewModel = ContactsMainScreenViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        screenViewModel.actions.viewWillAppear()
    }

    private func configureView() {
        navigationItem.title = R.string.localizable.contacts_main_screen_title()
        groupsBarButton.title = R.string.localizable.contacts_main_groups_button()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero) // to remove empty rows
        tableView.register(R.nib.contactsMainContactCell.self)
        tableView.register(R.nib.contactsMainLoadingCell.self)
        tableView.register(ContactsMainHeaderView.nib, forHeaderFooterViewReuseIdentifier: ContactsMainHeaderView.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func didTouchAddContactButton(_ sender: Any) {
        print("didTouchAddContactButton")
    }

    @IBAction func didTouchContactGroupsButton(_ sender: Any) {
        print("didTouchAddContactButton")
    }

    static func makeInstance() -> ContactsMainViewController {
        return Storyboard.Main.instantiate(viewControllerType: ContactsMainViewController.self)
    }
}

extension ContactsMainViewController: ContactsMainScreenViewModelDelegate, ErrorAlertPresentable {
    func contactsMainSetNeedReloadUI(_ event: ContactsMainEvent, viewModel: ContactsMainScreenViewModelType) {
        switch event {
        case .loading(let loading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
            tableView.reloadData()
        case .didLoadContacts:
            tableView.reloadData()
        case .error(let errorMessage):
            presentErrorAlert(message: errorMessage)
        }
    }
}

extension ContactsMainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return screenViewModel.dataSource.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = screenViewModel.dataSource.item(for: indexPath)
        let boundingSize = tableView.bounds.size
        switch item {
        case .loading:
            return ContactsMainLoadingCell.size(forBoundingSize: boundingSize).height
        case .contact:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let indexPath = IndexPath(row: 0, section: section)
        let item = screenViewModel.dataSource.item(for: indexPath)
        switch item {
        case .loading:
            return nil
        case .contact(let viewModel):
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactsMainHeaderView.reuseIdentifier) as? ContactsMainHeaderView else {
                return nil
            }
            headerView.titleLabel.text = viewModel.groupName
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let indexPath = IndexPath(row: 0, section: section)
        let item = screenViewModel.dataSource.item(for: indexPath)
        switch item {
        case .loading:
            return 0
        case .contact:
            return ContactsMainHeaderView.height
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = screenViewModel.dataSource.item(for: indexPath)
        switch item {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contactsMainLoadingCell, for: indexPath)!
            return cell
        case .contact:
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contactsMainContactCell, for: indexPath)!
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = screenViewModel.dataSource.item(for: indexPath)

        switch item {
        case .loading(let viewModel):
            guard let cell = cell as? ContactsMainLoadingCell else {
                assertionFailure("unexpected cell type found")
                return
            }
            cell.configure(with: viewModel)
        case .contact(let viewModel):
            guard let cell = cell as? ContactsMainContactCell else {
                assertionFailure("unexpected cell type found")
                return
            }
            cell.configure(with: viewModel)
        }
    }

}
