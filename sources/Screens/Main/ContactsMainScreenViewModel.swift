//
//  ContactsMainScreenViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import ContactModels
import ContactsNetwork
import Alamofire

enum ContactsMainScreenUIItem {
    case loading
}

protocol ContactsMainScreenViewModelDataSource {
    var screenTitle: String { get }
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func item(for indexPath: IndexPath) -> ContactsMainScreenUIItem
}

protocol ContactsMainScreenViewModelActions {
    func viewWillAppear()
}

protocol ContactsMainScreenViewModelDelegate: class {

}

protocol ContactsMainScreenViewModelType {
    var dataSource: ContactsMainScreenViewModelDataSource { get }
    var actions: ContactsMainScreenViewModelActions { get }
    var delegate: ContactsMainScreenViewModelDelegate? { get set }
}

final class ContactsMainScreenViewModel: ContactsMainScreenViewModelType, ContactsMainScreenViewModelDataSource, ContactsMainScreenViewModelActions {

    var dataSource: ContactsMainScreenViewModelDataSource { return self }
    var actions: ContactsMainScreenViewModelActions { return self }
    weak var delegate: ContactsMainScreenViewModelDelegate?
    private var isLoading = false
    private var dataSourceItems: [[ContactsMainScreenUIItem]] = []

    init() {
        updateDataSource()
    }

    private func updateDataSource() {

    }

    // MARK: DataSource
    var screenTitle: String {
        return "Contacts"
    }

    var numberOfSections: Int {
        return dataSourceItems.count
    }

    func numberOfItems(in section: Int) -> Int {
        return dataSourceItems[section].count
    }

    func item(for indexPath: IndexPath) -> ContactsMainScreenUIItem {
        return dataSourceItems[indexPath.section][indexPath.row]
    }

    // MARK: Actions:
    func viewWillAppear() {
        isLoading = true
        fetchContacts()
    }
}

extension ContactsMainScreenViewModel {
    // MARK: private
    private func fetchContacts() {
        let request = FetchContactsRequest()
        DataProvider.shared.request(.fetchAllContacts(request), source: .network) { (result: Result<[ContactsListPerson]>) in
            switch result {
            case .success(let contacts):
                print(contacts.map { "\($0.fullName)" })
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
}
