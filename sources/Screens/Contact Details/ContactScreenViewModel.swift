//
//  ContactScreenViewModel.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import ContactModels
import PromiseKit

enum ContactScreenUIItem {
    enum Preview {
        case profileHeader(ContactProfilePreviewCellViewModel)
        case mobilePhone(ContactFieldCellViewModel)
        case email(ContactFieldCellViewModel)
        case deleteContact(ContactActionCellViewModel)
    }

    enum Edit {
        case profileHeader(ContactProfilePreviewCellViewModel)
        case firstName(ContactFieldCellViewModel)
        case lastName(ContactFieldCellViewModel)
        case mobilePhone(ContactFieldCellViewModel)
        case email(ContactFieldCellViewModel)
    }

    enum AddNew {
        case profileHeader(ContactProfilePreviewCellViewModel)
        case firstName(ContactFieldCellViewModel)
        case lastName(ContactFieldCellViewModel)
        case mobilePhone(ContactFieldCellViewModel)
        case email(ContactFieldCellViewModel)
    }

    case preview(Preview)
    case edit(Edit)
    case addNew(AddNew)
    case loadingContact(ContactLoadingCellViewModel)
    case verticalSpace(CGFloat)
}

struct FieldsInput {
    var firstName: String?
    var lastName: String?
    var mobile: String?
    var email: String?
}

struct ContactScreenState {
    let initialMode: ContactScreenViewModel.Mode
    var mode: ContactScreenViewModel.Mode
    var contact: Person?
    var currentInput: FieldsInput?
    var isUpdatingFavourite: Bool
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
    func deleteContact()
    func handleAction(_ action: ContactProfileAction)
}

enum ContactScreenEvent {
    enum Error {
        case loadingData(String)
        case createContact(String)
        case deleteContact(String)
    }

    case setNeedReload
    case cancelAddNewContact
    case creatingNewContact
    case didCreateNewContact
    case didDeleteContact(contactId: Int)
    case setBusy(Bool)
    case didReceiveAnError(ContactScreenEvent.Error)
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

    private enum FieldDescription {
        static let firstName = R.string.localizable.contacts_details_first_name_field_title()
        static let lastName = R.string.localizable.contacts_details_last_name_field_title()
        static let mobile = R.string.localizable.contacts_details_mobile_field_title()
        static let email = R.string.localizable.contacts_details_email_field_title()
        static let deleteAction = R.string.localizable.contacts_details_delete_title()
    }

    var dataSource: ContactScreenViewModelDataSource { return self }
    var actions: ContactScreenViewModelActions { return self }
    weak var delegate: ContactScreenViewModelDelegate?
    private(set) var state: ContactScreenState

    private var dataSourceItems: [[ContactScreenUIItem]] = []

    typealias Dependencies = HasNetworkDataProvider
    private let dependencies: Dependencies

    init(mode: Mode, dependencies: Dependencies = AppDependencies.shared) {
        self.state = ContactScreenState(initialMode: mode,
                                        mode: mode,
                                        contact: nil,
                                        currentInput: nil,
                                        isUpdatingFavourite: false)
        self.dependencies = dependencies
        updateDataSource()
    }

    private func updateDataSource() {
        switch state.mode {
        case .view:
            if let contact = state.contact {
                dataSourceItems = makePreviewDataSource(contact)
            } else {
                dataSourceItems = makeLoadingContactDataSource()
            }
        case .edit:
            if let contact = state.contact {
                dataSourceItems = makeEditDataSource(contact)
            } else {
                dataSourceItems = makeLoadingContactDataSource()
            }
        case .addNew:
            dataSourceItems = makeAddContactDataSource()
        }
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
        fetchDataIfNeeded()
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
            updateDataSource()
            sendUIEvent(.setNeedReload)
        case .edit:
            assertionFailure("view state is inconsistent")
            return
        }
    }

    func deleteContact() {
        let contactId: Int?
        switch state.mode {
        case .edit(let id):
            contactId = id
        case .view(let id):
            contactId = id
        case .addNew:
            contactId = nil
        }

        guard let id = contactId else { return }

        sendUIEvent(.setBusy(true))
        firstly { Promises.deleteContact(id: id)
        }.done { _ in
            self.sendUIEvent(.didDeleteContact(contactId: id))
        }.ensure { self.sendUIEvent(.setBusy(false))
        }.catch {
            self.updateDataSource()
            self.sendUIEvent(.setNeedReload)
            self.sendUIEvent(.didReceiveAnError(.deleteContact($0.localizedDescription)))
        }
    }

    func handleAction(_ action: ContactProfileAction) {
        guard let contact = state.contact else {
            assertionFailure("datasource is inconsistent")
            return
        }

        switch action {
        case .message:
            print("message")
        case .call:
            print("call")
        case .email:
            print("email")
        case .favorite:
            setIsFavorite(!contact.isFavorite, contactId: contact.id)
        }
    }
}

extension ContactScreenViewModel {
    // MARK: private
    private func sendUIEvent(_ event: ContactScreenEvent) {
        switch event {
        case .creatingNewContact, .didCreateNewContact:
            updateDataSource()
        default:
            break
        }
        delegate?.contactsScreenHandleEvent(event, viewModel: self)
    }

    private func fetchDataIfNeeded() {
        let contactId: Int?
        switch state.mode {
        case .edit(let id):
            contactId = id
        case .view(let id):
            contactId = id
        case .addNew:
            contactId = nil
        }

        guard let id = contactId else { return }

        sendUIEvent(.setBusy(true))
        firstly {
            Promises.fetchContact(id: id)
        }.done {
            self.processContact($0)
            self.updateDataSource()
            self.sendUIEvent(.setNeedReload)
        }.ensure {
            self.sendUIEvent(.setBusy(false))
        }.catch {
            self.dataSourceItems = []
            self.sendUIEvent(.setNeedReload)
            self.sendUIEvent(.didReceiveAnError(.loadingData($0.localizedDescription)))
        }
    }

    private func makePreviewDataSource(_ contact: Person) -> [[ContactScreenUIItem]] {
        var dataSource: [[ContactScreenUIItem]] = []

        /*** Profile header ***/
        do {
            let viewModel = ContactProfilePreviewCellViewModel(contact: contact, isUpdatingFavorite: state.isUpdatingFavourite)
            dataSource += [[.preview(.profileHeader(viewModel))]]
        }

        /*** Mobile phone ***/
        do {
            let viewModel = ContactFieldCellViewModel.init(fieldDescription: FieldDescription.mobile,
                                                           fieldValue: state.contact?.mobile)
            dataSource += [[.preview(.mobilePhone(viewModel))]]
        }

        /*** Email ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.email,
                                                      fieldValue: state.contact?.email.absoluteString)
            dataSource += [[.preview(.email(viewModel))]]
        }

        /*** Delete button ***/
        do {
            let viewModel = ContactActionCellViewModel(actionTitle: FieldDescription.deleteAction)
            dataSource += [[.verticalSpace(23)]]
            dataSource += [[.preview(.deleteContact(viewModel))]]
            dataSource += [[.verticalSpace(25)]]
        }

        return dataSource
    }

    private func makeEditDataSource(_ contact: Person) -> [[ContactScreenUIItem]] {
        var dataSource: [[ContactScreenUIItem]] = []

        /*** Profile header ***/
        do {
            let viewModel = ContactProfilePreviewCellViewModel(contact: contact, isUpdatingFavorite: state.isUpdatingFavourite)
            dataSource += [[.edit(.profileHeader(viewModel))]]
        }

        /*** First name ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.firstName,
                                                      fieldValue: state.contact?.firstName)
            dataSource += [[.edit(.firstName(viewModel))]]
        }

        /*** Last name ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.lastName,
                                                      fieldValue: state.contact?.lastName)
            dataSource += [[.edit(.lastName(viewModel))]]
        }

        /*** Mobile ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.mobile,
                                                      fieldValue: state.contact?.mobile)
            dataSource += [[.edit(.mobilePhone(viewModel))]]
        }

        /*** Email ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.email,
                                                      fieldValue: state.contact?.email.absoluteString)
            dataSource += [[.edit(.email(viewModel))]]
        }

        return dataSource
    }

    private func makeAddContactDataSource() -> [[ContactScreenUIItem]] {
        var dataSource: [[ContactScreenUIItem]] = []

        /*** Profile header ***/
        do {
//            let viewModel = ContactProfilePreviewCellViewModel()
//            dataSource += [[.addNew(.profileHeader(viewModel))]]
        }

        /*** First name ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.firstName,
                                                      fieldValue: nil)
            dataSource += [[.addNew(.firstName(viewModel))]]
        }

        /*** Last name ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.lastName,
                                                      fieldValue: nil)
            dataSource += [[.addNew(.lastName(viewModel))]]
        }

        /*** Mobile ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.mobile,
                                                      fieldValue: nil)
            dataSource += [[.addNew(.mobilePhone(viewModel))]]
        }

        /*** Email ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.email,
                                                      fieldValue: nil)
            dataSource += [[.addNew(.email(viewModel))]]
        }

        return dataSource
    }

    private func makeLoadingContactDataSource() -> [[ContactScreenUIItem]] {
        let title = R.string.localizable.contacts_details_loading_contact_title()
        let viewModel = ContactLoadingCellViewModel(title: title, isAnimating: true)
        return [[.loadingContact(viewModel)]]
    }

    private func processContact(_ contact: Person) {
        state.contact = contact
    }

    private func setIsFavorite(_ isFavorite: Bool, contactId: Int) {

        let setBusy: (Bool) -> Void = { [weak self] busy in
            guard let self = self else { return }
            self.state.isUpdatingFavourite = busy
            self.updateDataSource()
            self.sendUIEvent(.setBusy(busy))
            self.sendUIEvent(.setNeedReload)
        }

        setBusy(true)
        firstly {
            Promises.updateContact(id: contactId, isFavorite: isFavorite)
        }.done {
            self.processContact($0)
            self.updateDataSource()
            self.sendUIEvent(.setNeedReload)
        }.ensure {
            setBusy(false)
        }.catch {
            self.updateDataSource()
            self.sendUIEvent(.setNeedReload)
            self.sendUIEvent(.didReceiveAnError(.deleteContact($0.localizedDescription)))
        }
    }
}
