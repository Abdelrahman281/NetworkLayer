//
//  NetworkLayerTests.swift
//  NetworkLayerTests
//
//  Created by AbdEl-Rahman Mahmoud on 10/7/19.
//  Copyright © 2019 AbdEl-Rahman Mahmoud. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class NetworkLayerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCallDataService() {
        
        let urlPath = "https://testingq.getsandbox.com/User"
        
        let promise = expectation(description: "StatusCode 200")
        
       NetworkLayer.shared.callDataService(urlPath: urlPath, method: HTTPMethod.GET, timeOutInterval: 30.0, responseClass: User, success: { obj in
        Swift.print("hello")
       }, failure: {error in
        Swift.print(error)
       })
        
    }
}
