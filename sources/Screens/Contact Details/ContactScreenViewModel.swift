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
import UIKit

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
    enum FieldType {
        case firstName, lastName, mobile, email
    }

    var firstName: String?
    var lastName: String?
    var mobile: String?
    var email: String?
    var profileImageURLString: String? // AWS eTag
    var avatarImage: UIImage?
}

struct ContactScreenState {
    let initialMode: ContactScreenViewModel.Mode
    var mode: ContactScreenViewModel.Mode
    var contact: Person?
    var currentInput: FieldsInput?
    var isUpdatingFavourite: Bool
    var isUploadingImage: Bool
}

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
    func didEditField(_ type: FieldsInput.FieldType, value: String?)
    func didPickAnAvatarPicture(_ image: UIImage)
}

enum ContactScreenEvent {
    enum Error {
        case loadingData(String)
        case createContact(String)
        case deleteContact(String)
        case updateContact(String)
    }

    case setNeedReload
    case cancelAddNewContact
    case creatingNewContact
    case didCreateNewContact(contactId: Int)
    case updatingOrLoadingContact(Bool)
    case didUpdateContact(contactId: Int)
    case didDeleteContact(contactId: Int)
    case setBusy(Bool)
    case didReceiveAnError(ContactScreenEvent.Error)
    case openMessageComposer(recepient: String, body: String?)
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
                                        currentInput: FieldsInput(),
                                        isUpdatingFavourite: false,
                                        isUploadingImage: false)
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
            let contact = state.contact
            state.currentInput?.firstName = contact?.firstName
            state.currentInput?.lastName = contact?.lastName
            state.currentInput?.mobile = contact?.mobile
            state.currentInput?.email = contact?.email.absoluteString
            state.currentInput?.profileImageURLString = contact?.profileImageURL.absoluteString
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
            addNewContact()
        case .view(let contactId):
            updateContactDetails(contactId: contactId)
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
            sendSMS()
        case .call:
            makeACall()
        case .email:
            writeEmail()
        case .favorite:
            setIsFavorite(!contact.isFavorite, contactId: contact.id)
        case .camera:
            break
        }
    }

    func didEditField(_ type: FieldsInput.FieldType, value: String?) {
        switch type {
        case .firstName:
            state.currentInput?.firstName = value
        case .lastName:
            state.currentInput?.lastName = value
        case .mobile:
            state.currentInput?.mobile = value
        case .email:
            state.currentInput?.email = value
        }
    }

    func didPickAnAvatarPicture(_ image: UIImage) {
        state.currentInput?.avatarImage = image

        let busy: (Bool) -> Void = { busy in
            self.state.isUploadingImage = busy
            self.updateDataSource()
            self.sendUIEvent(.updatingOrLoadingContact(busy))
            self.sendUIEvent(.setNeedReload)
        }

        firstly { S3ImageUploader.uploadImage(image: image)
        }.done { self.state.currentInput?.profileImageURLString = $0
        }.ensure { busy(false)
        }.catch { self.sendUIEvent(.didReceiveAnError(.updateContact($0.localizedDescription))) }
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
        guard state.contact == nil else { return }

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

        sendUIEvent(.updatingOrLoadingContact(true))
        firstly {
            Promises.fetchContact(id: id)
        }.done {
            self.processContact($0)
            self.updateDataSource()
            self.sendUIEvent(.setNeedReload)
        }.ensure {
            self.sendUIEvent(.updatingOrLoadingContact(false))
        }
        .catch {
            self.dataSourceItems = []
            self.sendUIEvent(.setNeedReload)
            self.sendUIEvent(.didReceiveAnError(.loadingData($0.localizedDescription)))
        }
    }

    private func makePreviewDataSource(_ contact: Person) -> [[ContactScreenUIItem]] {
        var dataSource: [[ContactScreenUIItem]] = []

        /*** Profile header ***/
        do {
            let viewModel = ContactProfilePreviewCellViewModel(contact: contact,
                                                               isUpdatingFavorite: state.isUpdatingFavourite,
                                                               state: .view)
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
            let viewModel = ContactProfilePreviewCellViewModel(contact: contact,
                                                               isUpdatingFavorite: state.isUpdatingFavourite,
                                                               isUploadingImage: state.isUploadingImage,
                                                               state: .edit,
                                                               avatarImage: state.currentInput?.avatarImage)
            dataSource += [[.edit(.profileHeader(viewModel))]]
        }

        /*** First name ***/
        do {
            let value = state.currentInput?.firstName ?? state.contact?.firstName
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.firstName,
                                                      fieldValue: value,
                                                      editingAllowed: true)
            dataSource += [[.edit(.firstName(viewModel))]]
        }

        /*** Last name ***/
        do {
            let value = state.currentInput?.lastName ?? state.contact?.lastName
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.lastName,
                                                      fieldValue: value,
                                                      editingAllowed: true)
            dataSource += [[.edit(.lastName(viewModel))]]
        }

        /*** Mobile ***/
        do {
            let value = state.currentInput?.mobile ?? state.contact?.mobile
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.mobile,
                                                      fieldValue: value,
                                                      editingAllowed: true)
            dataSource += [[.edit(.mobilePhone(viewModel))]]
        }

        /*** Email ***/
        do {
            let value = state.currentInput?.email ?? state.contact?.email.absoluteString
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.email,
                                                      fieldValue: value,
                                                      editingAllowed: true,
                                                      returnKeyType: .done)
            dataSource += [[.edit(.email(viewModel))]]
        }

        return dataSource
    }

    private func makeAddContactDataSource() -> [[ContactScreenUIItem]] {
        var dataSource: [[ContactScreenUIItem]] = []

        /*** Profile header ***/
        do {
            let viewModel = ContactProfilePreviewCellViewModel(contact: nil,
                                                               isUpdatingFavorite: state.isUpdatingFavourite,
                                                               state: .add,
                                                               avatarImage: state.currentInput?.avatarImage)
            dataSource += [[.addNew(.profileHeader(viewModel))]]
        }

        /*** First name ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.firstName,
                                                      fieldValue: nil,
                                                      editingAllowed: true)
            dataSource += [[.addNew(.firstName(viewModel))]]
        }

        /*** Last name ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.lastName,
                                                      fieldValue: nil,
                                                      editingAllowed: true)
            dataSource += [[.addNew(.lastName(viewModel))]]
        }

        /*** Mobile ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.mobile,
                                                      fieldValue: nil,
                                                      editingAllowed: true)
            dataSource += [[.addNew(.mobilePhone(viewModel))]]
        }

        /*** Email ***/
        do {
            let viewModel = ContactFieldCellViewModel(fieldDescription: FieldDescription.email,
                                                      fieldValue: nil,
                                                      editingAllowed: true,
                                                      returnKeyType: .done)
            dataSource += [[.addNew(.email(viewModel))]]
        }

        return dataSource
    }

    private func makeLoadingContactDataSource() -> [[ContactScreenUIItem]] {
        return []
        /*
        let title = R.string.localizable.contacts_details_loading_contact_title()
        let viewModel = ContactLoadingCellViewModel(title: title, isAnimating: true)
        return [[.loadingContact(viewModel)]]
         */
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
            self.sendUIEvent(.didUpdateContact(contactId: contactId))
            self.sendUIEvent(.setNeedReload)
        }.ensure {
            setBusy(false)
        }.catch {
            self.updateDataSource()
            self.sendUIEvent(.setNeedReload)
            self.sendUIEvent(.didReceiveAnError(.updateContact($0.localizedDescription)))
        }
    }

    private func updateContactDetails(contactId: Int) {
        guard let contact = state.contact, let input = state.currentInput,
                  (contact.firstName != input.firstName) ||
                  (contact.lastName != input.lastName) ||
                  (contact.mobile != input.mobile) ||
                  (contact.email.absoluteString != input.email) ||
                  (contact.profileImageURL.absoluteString != input.profileImageURLString) else {
                state.mode = .view(contactId: contactId)
                updateDataSource()
                sendUIEvent(.setNeedReload)
                return
        }

        sendUIEvent(.updatingOrLoadingContact(true))
        firstly {
            updateContactFields(id: contactId)
        }.done {
            self.state.mode = .view(contactId: contactId)
            self.state.currentInput = FieldsInput()
            self.processContact($0)
            self.sendUIEvent(.didUpdateContact(contactId: contactId))
        }.ensure {
            self.updateDataSource()
            self.sendUIEvent(.updatingOrLoadingContact(false))
            self.sendUIEvent(.setNeedReload)
        }.catch {
            self.sendUIEvent(.didReceiveAnError(.updateContact($0.localizedDescription)))
        }
    }

    private func updateContactFields(id: Int) -> Promise<Person> {
        return Promises.updateContact(id: id,
                                      firstName: state.currentInput?.firstName,
                                      lastName: state.currentInput?.lastName,
                                      email: state.currentInput?.email,
                                      mobile: state.currentInput?.mobile,
                                      profileImageURLString: state.currentInput?.profileImageURLString)
    }

    private func addNewContact() {
        let input = state.currentInput
        guard let firstName = input?.firstName, firstName.notEmpty else {
            sendUIEvent(.didReceiveAnError(.createContact("first name can not be empty")))
            return
        }
        guard let lastName = input?.lastName, lastName.notEmpty else {
            sendUIEvent(.didReceiveAnError(.createContact("last name can not be empty")))
            return
        }
        guard let mobile = input?.mobile, mobile.notEmpty else {
            sendUIEvent(.didReceiveAnError(.createContact("phone number can not be empty")))
            return
        }
        guard let email = input?.email, email.notEmpty else {
            sendUIEvent(.didReceiveAnError(.createContact("email can not be empty")))
            return
        }

        let createContactPromise = Promises.createContact(firstName: firstName,
                                                          lastName: lastName,
                                                          email: email,
                                                          mobile: mobile,
                                                          profileImageURLString: state.currentInput?.profileImageURLString)

        sendUIEvent(.updatingOrLoadingContact(true))
        firstly {
            createContactPromise
        }.done {
            self.processContact($0)
            self.state.mode = .view(contactId: $0.id)
            self.state.currentInput = FieldsInput()
            self.sendUIEvent(.didCreateNewContact(contactId: $0.id))
        }.ensure {
            self.updateDataSource()
            self.sendUIEvent(.updatingOrLoadingContact(false))
            self.sendUIEvent(.setNeedReload)
        }.catch {
            self.sendUIEvent(.didReceiveAnError(.createContact($0.localizedDescription)))
        }
        return
    }

    private func sendSMS() {
        guard let mobile = state.contact?.mobile else { return }
        sendUIEvent(.openMessageComposer(recepient: mobile, body: "Hi! How are you?"))
    }

}
