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
        return dataProvider.request(route, source: source, decoder: decoder, completion: completion)
    }
}
