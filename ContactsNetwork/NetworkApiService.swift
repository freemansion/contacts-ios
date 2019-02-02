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
        case .fetchAllContacts:
            return .get
        }
    }

    public var sampleData: Data {
        switch self {
        case .fetchAllContacts: return sampleData(fromJsonFile: "get_all_contacts_success")
        }
    }

    public var task: Task {
        switch self {
        case .fetchAllContacts:
            return .requestParameters(parameters: requestData.bodyParameters, encoding: URLEncoding.queryString)
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
