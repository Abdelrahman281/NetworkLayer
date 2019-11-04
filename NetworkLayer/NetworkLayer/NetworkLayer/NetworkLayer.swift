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

class NetworkLayer: NSObject, URLSessionDelegate {
    
    
    //Shared instance for universal use.
    
    static let shared: NetworkLayer = NetworkLayer()
    
    
    //Delegate Queue.
    
    let delegateQueue: OperationQueue
    
    
    //Private Initializer.
    
    private override init(){
        delegateQueue = OperationQueue()
    }
    
    
    //Main Function For Calling Services.
    
    func callService<T: Decodable>(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: Any]? = nil, parameters: [String: Any]? = nil, success: @escaping SuccessBlock<T>, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: encodedURL) else { return }
        
        
        //Constructing URL Request.
        
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        
        
        //Constrcuting URL Session.
      
        let urlSesssion = URLSession.init(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        
        
        //Constructing Data Task.
        
        let dataTask = urlSesssion.dataTask(with: urlRequest){data, urlResponse, error in
            
            
            //Handling Error Case.
            
            if let err = error {
                failure(err)
                return
            }
            
            
            //Checking For Success Response.
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                    if let responseData = data {
                        do {
                            let responseObj = try JSONDecoder().decode(T.self, from: responseData)
                            success(responseObj)
                        } catch {
                            failure(error)
                        }
                    }
                }
            }
        }
        
        
        //Start The Task.
        
        dataTask.resume()
    }
}
