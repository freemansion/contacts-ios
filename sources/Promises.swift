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

    static func deleteContact(id: Int) -> Promise<Bool> {
        let request = DeleteContactRequest(contactId: id)
        return dependencies.dataProvider.request(route: .deleteContact(request),
                                                 expectedStatusCodes: request.expectedStatusCodes)
    }
}
