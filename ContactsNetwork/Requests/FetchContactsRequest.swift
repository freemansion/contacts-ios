//
//  FetchContactsRequest.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public struct FetchContactsRequest: RequestDataProvidable {

    public init() {}

    var endpoint: String {
        return "/contacts.json"
    }

}
