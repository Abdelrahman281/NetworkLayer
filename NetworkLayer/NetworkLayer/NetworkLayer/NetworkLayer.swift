//
//  NetworkLayer.swift
//  NetworkLayer
//
//  Created by Abdelrahman Mahmoud on 10/7/19.
//  Copyright © 2019 AbdEl-Rahman Mahmoud. All rights reserved.
//

import Foundation


//Representation of success&failure blocks.

typealias SuccessBlock<T: Decodable> = (T) -> Void
typealias FailureBlock = (Error) -> Void


//Main class for network operations.

class NetworkLayer {
    
    
    //Shared instance for universal use.
    
    static let shared: NetworkLayer = NetworkLayer()
    
    
    //Main Function For Calling Services.
    
    func callService<T: Decodable>(url: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: Any]? = nil, parameters: [String: Any]? = nil, success: SuccessBlock<T>, failure: FailureBlock) {
        
    }
    
    
}
