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
    case loading(ContactsMainLoadingCellViewModel)
    case contact(ContactsMainContactCellViewModel)
}

protocol ContactsMainScreenViewModelDataSource {
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func item(for indexPath: IndexPath) -> ContactsMainScreenUIItem
    var sectionIndexTitles: [String]? { get }
}

protocol ContactsMainScreenViewModelActions {
    func viewWillAppear()
}

enum ContactsMainEvent {
    case loading(Bool)
    case error(String)
    case didLoadContacts
}

protocol ContactsMainScreenViewModelDelegate: class {
    func contactsMainSetNeedReloadUI(_ event: ContactsMainEvent, viewModel: ContactsMainScreenViewModelType)
}

protocol ContactsMainScreenViewModelType {
    var dataSource: ContactsMainScreenViewModelDataSource { get }
    var actions: ContactsMainScreenViewModelActions { get }
    var delegate: ContactsMainScreenViewModelDelegate? { get set }
}

struct ContactsMainState {
    var contacts: [ContactsListPerson] = []
    var groupedContacts: [(String, [ContactsListPerson])] = []
}

final class ContactsMainScreenViewModel: ContactsMainScreenViewModelType, ContactsMainScreenViewModelDataSource, ContactsMainScreenViewModelActions {

    private enum Constants {
        static let loadingTitle = R.string.localizable.contacts_main_loading_contacts_title()
        static let personPlaceholder = R.image.person_placeholder()!
    }

    var dataSource: ContactsMainScreenViewModelDataSource { return self }
    var actions: ContactsMainScreenViewModelActions { return self }
    weak var delegate: ContactsMainScreenViewModelDelegate?
    private var isLoading = false
    private var dataSourceItems: [[ContactsMainScreenUIItem]] = []

    typealias Dependencies = HasNetworkDataProvider
    private let dependencies: Dependencies
    private var state: ContactsMainState

    init(state: ContactsMainState = ContactsMainState(), dependencies: Dependencies = AppDependencies.shared) {
        self.state = state
        self.dependencies = dependencies
        updateDataSource()
    }

    private func updateDataSource() {
        var newDataSourceItems: [[ContactsMainScreenUIItem]] = []
        if isLoading {
            let viewModel = ContactsMainLoadingCellViewModel(title: Constants.loadingTitle,
                                                             isAnimating: true)
            newDataSourceItems += [[.loading(viewModel)]]
        } else if !state.contacts.isEmpty {
            for group in state.groupedContacts {
                let contacts = group.1.map { ContactsMainContactCellViewModel(groupName: group.0,
                                                                              contact: $0,
                                                                              placeholderIcon: Constants.personPlaceholder) }
                                      .map { ContactsMainScreenUIItem.contact($0) }
                newDataSourceItems += [contacts]
            }
        } else {
            // no data :/
        }

        dataSourceItems = newDataSourceItems
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

    var sectionIndexTitles: [String]? {
        return state.groupedContacts.map { $0.0 }
    }

    // MARK: Actions:
    func viewWillAppear() {
        if state.contacts.isEmpty {
            fetchContacts()
        }
    }
}

extension ContactsMainScreenViewModel {
    // MARK: private
    private func fetchContacts() {
        sendUIEvent(.loading(true))
        firstly { Promises.fetchAllContacts()
        }.done {
            self.processContacts($0)
            self.sendUIEvent(.didLoadContacts)
        }.ensure { self.sendUIEvent(.loading(false))
        }.catch { self.sendUIEvent(.error($0.localizedDescription)) }
    }

    private func sendUIEvent(_ event: ContactsMainEvent) {
        switch event {
        case .loading(let loading):
            isLoading = loading
        case .didLoadContacts, .error:
            break
        }
        updateDataSource()
        delegate?.contactsMainSetNeedReloadUI(event, viewModel: self)
    }

    private func processContacts(_ contacts: [ContactsListPerson]) {
        // 1. sort alpabetically by full name
        let sorted = contacts.sorted(by: { $0.fullName < $1.fullName })

        // 2. split by groups
        var result: [(String, [ContactsListPerson])] = []
        for contact in sorted {
            if let firstChar = contact.fullName.first, let section = result.last, String(firstChar) == section.0 {
                // updating existing group
                let group = (String(firstChar), (section.1 + [contact]))
                result.removeLast()
                result.append(group)
            } else if let firstChar = contact.fullName.first {
                // creating new one
                let group = (String(firstChar), [contact])
                result.append(group)
            }

            // print("\(result.map { "section: \($0.0), contacts: \($0.1.count)" })\n")
        }

        state.contacts = sorted
        state.groupedContacts = result
    }
}
