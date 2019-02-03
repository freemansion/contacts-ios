//
//  NetworkApiService.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import Moya

public enum NetworkApiService {
    case fetchAllContacts(FetchContactsRequest)
    case fetchContact(FetchContactRequest)
    case deleteContact(DeleteContactRequest)
}

extension NetworkApiService: TargetType {
    public var baseURL: URL {
        return URL(string: "https://young-atoll-90416.herokuapp.com")!
    }

    public var path: String {
        return requestData.endpoint
    }

    public var method: Moya.Method {
        switch self {
        case .fetchAllContacts, .fetchContact:
            return .get
        case .deleteContact:
            return .delete
        }
    }

    public var sampleData: Data {
        switch self {
        case .fetchAllContacts: return sampleData(fromJsonFile: "get_all_contacts_success")
        case .fetchContact: return sampleData(fromJsonFile: "fetch_contact_success")
        case .deleteContact: return Data()
        }
    }

    public var task: Task {
        switch self {
        case .fetchAllContacts, .fetchContact:
            return .requestParameters(parameters: requestData.bodyParameters, encoding: URLEncoding.queryString)
        case .deleteContact:
            if requestData.urlParameters.isEmpty {
                return .requestParameters(parameters: requestData.bodyParameters,
                                          encoding: JSONEncoding.default)
            } else {
                return .requestCompositeParameters(bodyParameters: requestData.bodyParameters,
                                                   bodyEncoding: JSONEncoding.default,
                                                   urlParameters: requestData.urlParameters)
            }
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }

}

private extension NetworkApiService {
    func sampleData(fromJsonFile fileName: String) -> Data {
        // Returns sample data for network requests
        let bundle = Bundle(for: DataProvider.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
}

public protocol NetworkApiServiceRepresentable {}
// conformance to `NetworkApiServiceRepresentable` required to be found by Sourcery
extension NetworkApiService: NetworkApiServiceRepresentable {}
