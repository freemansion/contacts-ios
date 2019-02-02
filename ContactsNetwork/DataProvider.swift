//
//  DataProvider.swift
//  ContactsNetwork
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public final class DataProvider {
    public enum NetworkDataSource {
        case network
        case sampleData
    }

    public static let shared = DataProvider()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601Full)
        return encoder
    }()

    private init() {}

    public func request<T: Decodable>(_ route: NetworkApiService,
                                      source: NetworkDataSource = .network,
                                      decoder: JSONDecoder? = nil,
                                      completion: @escaping (Result<T>) -> Void) {
        let _decoder = decoder ?? self.decoder
        let provider = dataProvider(forSource: source)
        provider.request(route) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let json = try filteredResponse.mapJSON()
                        let decodedObject = try ModelMapper.default.map(T.self, from: json, decoder: _decoder)
                        completion(.success(decodedObject))
                    } catch {
                        let _error = ServerAPIError.other(error)
                        completion(.failure(_error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension DataProvider {
    private static func dataProvider(forSource source: NetworkDataSource) -> MoyaProvider<NetworkApiService> {

        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        /*** Moya plug-ins ***/
        var plugins: [PluginType] = []
        #if DEBUG
        plugins.append(NetworkLoggerPlugin.logger)
        #endif
        /***  ***/

        let manager = Manager(configuration: configuration)

        switch source {
        case .network:
            return MoyaProvider<NetworkApiService>(manager: manager, plugins: plugins)
        case .sampleData:
            let endpoint = { (target: NetworkApiService) -> Endpoint in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            }
            let provider = MoyaProvider<NetworkApiService>(endpointClosure: endpoint, stubClosure: MoyaProvider.immediatelyStub)
            return provider
        }
    }

    private func dataProvider(forSource source: NetworkDataSource) -> MoyaProvider<NetworkApiService> {
        switch source {
        case .network:
            return DataProvider.dataProvider(forSource: .network)
        case .sampleData:
            return DataProvider.dataProvider(forSource: .sampleData)
        }
    }
}

extension DateFormatter {
    public static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
