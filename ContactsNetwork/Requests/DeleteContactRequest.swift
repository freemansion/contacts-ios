//
//  DeleteContactRequest.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public struct DeleteContactRequest: RequestDataProvidable {

    public let contactId: Int
    public var expectedStatusCodes: ClosedRange<Int> { return 204...204 }

    public init(contactId: Int) {
        self.contactId = contactId
    }

    var endpoint: String {
        return "/contacts/\(contactId).json"
    }

}
