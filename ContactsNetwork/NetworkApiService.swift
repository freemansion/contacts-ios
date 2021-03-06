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
    case createContact(CreateContactRequest)
    case updateContact(UpdateContactDetailsRequest)
    case deleteContact(DeleteContactRequest)
}

public enum Environment {
    case development(baseURL: URL)

    var serverURL: URL {
        switch self {
        case .development(let url):
            return url
        }
    }
}

extension NetworkApiService: TargetType {

    private static var env: Environment?

    public static func setupEnvironment(usingEnv env: Environment) {
        NetworkApiService.env = env
    }

    public var baseURL: URL {
        guard let env = NetworkApiService.env else {
            fatalError("network environment must be set")
        }
        return env.serverURL
    }

    public var path: String {
        return requestData.endpoint
    }

    public var method: Moya.Method {
        switch self {
        case .fetchAllContacts, .fetchContact:
            return .get
        case .createContact:
            return .post
        case .updateContact:
            return .put
        case .deleteContact:
            return .delete
        }
    }

    public var sampleData: Data {
        switch self {
        case .fetchAllContacts: return sampleData(fromJsonFile: "get_all_contacts_success")
        case .fetchContact: return sampleData(fromJsonFile: "fetch_contact_success")
        case .createContact: return sampleData(fromJsonFile: "create_contact_success")
        case .updateContact: return sampleData(fromJsonFile: "update_contact_success")
        case .deleteContact: return Data()
        }
    }

    public var task: Task {
        switch self {
        case .fetchAllContacts, .fetchContact:
            return .requestParameters(parameters: requestData.bodyParameters, encoding: URLEncoding.queryString)
        case .createContact, .updateContact, .deleteContact:
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
        switch self {
        case .deleteContact:
            return nil
        default:
            return ["Content-Type": "application/json; charset=utf-8"]
        }
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
