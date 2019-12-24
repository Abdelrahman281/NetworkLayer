//
//  NetworkLayerTests.swift
//  NetworkLayerTests
//
//  Created by Abdelrahman Mahmoud on 10/7/19.
//  Copyright © 2019 Abdelrahman Mahmoud. All rights reserved.
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

    
    //Sample function for Unit Testing.
    
    func testCallDataService() {
        let urlPath = "https://testingq.getsandbox.com/User"
        
        //Creating XCTestExpectation for expecting API Success.
        
        let promise = expectation(description: "StatusCode 200")
        
        NetworkLayer.shared.callDataService(urlPath: urlPath, method: HTTPMethod.GET, timeOutInterval: 30.0, postData: nil, responseClass: User.self, success: { responseObj in
            if responseObj is User {
                
                //Matched the expectation.
                
                promise.fulfill()
            }
       }, failure: {error in
        
        //Failure case.
        
        XCTFail()
       })
        wait(for: [promise], timeout: 10.0)
        XCTFail()
    }
}
