//
//  ContactScreenViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

enum ContactScreenUIItem {
    case item1
}

struct ContactScreenState {
    let initialMode: ContactScreenViewModel.Mode
    var mode: ContactScreenViewModel.Mode
}
var previousMode: ContactScreenViewModel.Mode?

protocol ContactScreenViewModelDataSource {
    var state: ContactScreenState { get }
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func item(for indexPath: IndexPath) -> ContactScreenUIItem
}

protocol ContactScreenViewModelActions {
    func viewWillAppear()
    func didTouchEdit()
    func didTouchCancel()
    func didTouchDone()
}

enum ContactScreenEvent {
    case setNeedReload
    case cancelAddNewContact
    case creatingNewContact
    case didCreateNewContact
}

protocol ContactScreenViewModelDelegate: class {
    func contactsScreenHandleEvent(_ event: ContactScreenEvent, viewModel: ContactScreenViewModelType)
}

protocol ContactScreenViewModelType {
    var dataSource: ContactScreenViewModelDataSource { get }
    var actions: ContactScreenViewModelActions { get }
    var delegate: ContactScreenViewModelDelegate? { get set }
}

final class ContactScreenViewModel: ContactScreenViewModelType, ContactScreenViewModelDataSource, ContactScreenViewModelActions {

    enum Mode {
        case addNew
        case view(contactId: Int)
        case edit(contactId: Int)
    }

    var dataSource: ContactScreenViewModelDataSource { return self }
    var actions: ContactScreenViewModelActions { return self }
    weak var delegate: ContactScreenViewModelDelegate?
    private(set) var state: ContactScreenState

    private var dataSourceItems: [[ContactScreenUIItem]] = []

    typealias Dependencies = HasNetworkDataProvider
    private let dependencies: Dependencies

    init(mode: Mode, dependencies: Dependencies = AppDependencies.shared) {
        self.state = ContactScreenState(initialMode: mode, mode: mode)
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

    func item(for indexPath: IndexPath) -> ContactScreenUIItem {
        return dataSourceItems[indexPath.section][indexPath.row]
    }

    // MARK: Actions:
    func viewWillAppear() {

    }

    func didTouchEdit() {
        switch state.mode {
        case .view(let contactId):
            state.mode = .edit(contactId: contactId)
        case .addNew, .edit:
            assertionFailure("view state is inconsistent")
            return
        }
        updateDataSource()
        sendUIEvent(.setNeedReload)
    }

    func didTouchCancel() {
        switch state.initialMode {
        case .addNew:
            sendUIEvent(.cancelAddNewContact)
        case .view(let contactId):
            state.mode = .view(contactId: contactId)
            updateDataSource()
            sendUIEvent(.setNeedReload)
        case .edit:
            assertionFailure("view state is inconsistent")
            return
        }
    }

    func didTouchDone() {
        switch state.initialMode {
        case .addNew:

            // create entity and retrieve id
            state.mode = .view(contactId: 1)

            sendUIEvent(.creatingNewContact)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.sendUIEvent(.didCreateNewContact)
            }
            return

        case .view:
            // create entity and retrieve id
            state.mode = .view(contactId: 1)
        case .edit:
            assertionFailure("view state is inconsistent")
            return
        }

        updateDataSource()
        sendUIEvent(.setNeedReload)
    }
}

extension ContactScreenViewModel {
    // MARK: private
    fileprivate func sendUIEvent(_ event: ContactScreenEvent) {
        switch event {
        case .creatingNewContact, .didCreateNewContact:
            updateDataSource()
        default:
            break
        }
        delegate?.contactsScreenHandleEvent(event, viewModel: self)
    }
}
