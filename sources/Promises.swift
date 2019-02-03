//
//  Promises.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import ContactModels
import ContactsNetwork
import PromiseKit

struct Promises {
    typealias Dependencies = HasNetworkDataProvider
    private static let dependencies = AppDependencies.shared

    static func fetchAllContacts() -> Promise<[ContactsListPerson]> {
        let request = FetchContactsRequest()
        return dependencies.dataProvider.request(data: [ContactsListPerson].self,
                                                 route: .fetchAllContacts(request))
    }

    static func fetchContact(id: Int) -> Promise<Person> {
        let request = FetchContactRequest(contactId: id)
        return dependencies.dataProvider.request(data: Person.self,
                                                 route: .fetchContact(request))
    }

    static func createContact(firstName: String,
                              lastName: String,
                              email: String,
                              mobile: String,
                              profileImageURLString: String? = nil) -> Promise<Person> {
        let request = CreateContactRequest(firstName: firstName, lastName: lastName, email: email, mobile: mobile, profileImageURLString: profileImageURLString)
        return dependencies.dataProvider.request(data: Person.self,
                                                 route: .createContact(request))
    }

    static func updateContact(id: Int,
                              firstName: String? = nil,
                              lastName: String? = nil,
                              email: String? = nil,
                              mobile: String? = nil,
                              profileImageURLString: String? = nil,
                              isFavorite: Bool? = nil) -> Promise<Person> {
        let request = UpdateContactDetailsRequest(contactId: id, firstName: firstName, lastName: lastName, email: email, mobile: mobile, profileImageURLString: profileImageURLString, isFavorite: isFavorite)
        return dependencies.dataProvider.request(data: Person.self,
                                                 route: .updateContact(request))
    }

    static func deleteContact(id: Int) -> Promise<Bool> {
        let request = DeleteContactRequest(contactId: id)
        return dependencies.dataProvider.request(route: .deleteContact(request),
                                                 expectedStatusCodes: request.expectedStatusCodes)
    }

}
