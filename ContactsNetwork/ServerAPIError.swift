//
//  ServerAPIError.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

public enum ServerAPIError: LocalizedError {
    case wrongStatusCode(error: Error, statusCode: Int, expectedStatusCodes: ClosedRange<Int>)
    case unexpectedDataFormat
    case other(error: Error, description: String?)

    public var errorDescription: String? {
        switch self {
        case .wrongStatusCode(_, let statusCode, let expectedStatusCodes):
            let expectedCodesString = [Int](expectedStatusCodes).map { "\($0)" }.joined(separator: ", ")
            return "Wrong status code: \(statusCode), expected status codes: \(expectedCodesString)"
        case .unexpectedDataFormat:
            return "Unexpected data format"
        case .other(let error, let description):
            return description ?? error.localizedDescription
        }
    }
}
