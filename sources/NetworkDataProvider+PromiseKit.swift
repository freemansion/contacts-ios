//
//  NetworkDataProvider+PromiseKit.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import ContactModels
import ContactsNetwork
import Alamofire
import PromiseKit

protocol NetworkDataPromisable {
    /** returns promise containing Codable model object
    - parameter data: type of an expected Codable model object. For ex.: `ContactsListPerson.self`
    - parameter route: enum case containing network request data.
    - parameter source: data source where to request a data, i.e. from network or local json file.
    - parameter decoder: optional param for decoding requested type.
    */
    func request<T: Codable>(data: T.Type,
                             route: NetworkApiService,
                             source: DataProvider.Source,
                             decoder: JSONDecoder?) -> Promise<T>

    /** returns promise containing Codable model object
    - parameter route: enum case containing network request data.
    - parameter source: data source where to request a data, i.e. from network or local json file.
    - parameter expectedStatusCodes: range of accpeted status codes, result will containt boolean value depending on a given range.
    */
    func request(route: NetworkApiService,
                 source: DataProvider.Source,
                 expectedStatusCodes: ClosedRange<Int>?) -> Promise<Bool>
}

extension NetworkDataProvider: NetworkDataPromisable {
    func request<T: Codable>(data: T.Type,
                             route: NetworkApiService,
                             source: DataProvider.Source = .network,
                             decoder: JSONDecoder? = nil) -> Promise<T> {
        return Promise { resolver in
            request(route, source: source, decoder: decoder, completion: { (result: Alamofire.Result<T>) in
                switch result {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }

    func request(route: NetworkApiService,
                 source: DataProvider.Source = .network,
                 expectedStatusCodes: ClosedRange<Int>? = nil) -> Promise<Bool> {
        return Promise { resolver in
            request(route, source: source, successStatusCodes: expectedStatusCodes, completion: { (result: Alamofire.Result<Bool>) in
                switch result {
                case .success(let value):
                    resolver.fulfill(value)
                case .failure(let error):
                    resolver.reject(error)
                }
            })
        }
    }
}
