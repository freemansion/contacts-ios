//
//  RequestDataProvidable.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

protocol RequestDataProvidable {
    var endpoint: String { get }
    var urlParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
}

extension RequestDataProvidable {
    var urlParameters: [String: Any] { return [:] }
    var bodyParameters: [String: Any] { return [:] }
}
