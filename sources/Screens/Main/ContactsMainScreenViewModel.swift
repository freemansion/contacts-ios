//
//  ContactsMainScreenViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import ContactModels
import PromiseKit

enum ContactsMainScreenUIItem {
    case loading
}

protocol ContactsMainScreenViewModelDataSource {
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func item(for indexPath: IndexPath) -> ContactsMainScreenUIItem
}

protocol ContactsMainScreenViewModelActions {
    func viewWillAppear()
}

enum ContactsMainEvent {
    case error(String)
    case didLoadData
}

protocol ContactsMainScreenViewModelDelegate: class {
    func contactsMainSetNeedReloadUI(_ event: ContactsMainEvent, viewModel: ContactsMainScreenViewModelType)
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

    typealias Dependencies = HasNetworkDataProvider
    private let dependencies: Dependencies

    init(dependencies: Dependencies = AppDependencies.shared) {
        self.dependencies = dependencies
        updateDataSource()
    }

    private func updateDataSource() {

    }

    // MARK: DataSource
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
        firstly { Promises.fetchAllContacts()
        }.done { _ in self.sendUIEvent(.didLoadData)
        }.ensure { self.updateDataSource()
        }.catch { self.sendUIEvent(.error($0.localizedDescription)) }
    }

    private func sendUIEvent(_ event: ContactsMainEvent) {
        delegate?.contactsMainSetNeedReloadUI(event, viewModel: self)
    }
}
