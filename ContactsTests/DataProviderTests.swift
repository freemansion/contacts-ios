//
//  DataProviderTests.swift
//  ContactsTests
//
//  Created by Stanislau Baranouski on 2/5/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import XCTest
@testable import Contacts
import ContactModels
import ContactsNetwork
import Moya
import Alamofire
import PromiseKit

class DataProviderTests: XCTestCase {
    
    typealias Dependencies = HasNetworkDataProvider
    private let dependencies: Dependencies! = AppDependencies.shared
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func customEndpointClosure(_ target: NetworkApiService) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAllContacts() {
        let expectation = self.expectation(description: #function)
        var result: [ContactsListPerson] = []
        
        let request = FetchContactsRequest()
        dependencies.dataProvider.request(.fetchAllContacts(request), source: .sampleData) { (response: Alamofire.Result<[ContactsListPerson]>) in
            switch response {
            case .success(let _result):
                result = _result
                expectation.fulfill()
            case .failure:
                break
            }
        }
    
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(!result.isEmpty)
    }

}
