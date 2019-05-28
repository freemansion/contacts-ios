//
//  NetworkDataProvider.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import ContactModels
import ContactsNetwork
import Alamofire

/** NetworkDataProvider is a bridge class between main app and ContactsNetwork module **/
final class NetworkDataProvider {
    private let dataProvider: DataProvider

    init(dataProvider: DataProvider = .shared) {
        self.dataProvider = dataProvider
    }
}

extension NetworkDataProvider: DataProviderProtocol {
    func request<T>(_ route: NetworkApiService,
                    source: DataProvider.Source = .network,
                    decoder: JSONDecoder? = nil,
                    completion: @escaping (Alamofire.Result<T>) -> Void) where T: Codable {
        dataProvider.request(route, source: source, decoder: decoder, completion: completion)
    }

    func request(_ route: NetworkApiService,
                 source: DataProvider.Source = .network,
                 successStatusCodes: ClosedRange<Int>? = nil,
                 completion: @escaping (Result<Bool>) -> Void) {
        dataProvider.request(route, source: source, successStatusCodes: successStatusCodes, completion: completion)
    }
}
