//
//  NetworkLayer.swift
//  NetworkLayer
//
//  Created by Abdelrahman Mahmoud on 10/7/19.
//  Copyright © 2019 Abdelrahman Mahmoud. All rights reserved.
//

import Foundation


//Representation of Success&Failure Blocks.

typealias SuccessBlock = (Decodable) -> Void
typealias SuccessBlockWithoutObject = ()  -> Void
typealias FailureBlock = (Error?) -> Void


//Main Class For Network Operations.

class NetworkLayer: NSObject, URLSessionDelegate {
    
    
    //Shared Instance For Universal Use.
    
    static let shared: NetworkLayer = NetworkLayer()
    
    
    //Delegate Queue.
    
    private let delegateQueue: OperationQueue
    
    
    //Private Initializer.
    
    private override init(){
        delegateQueue = OperationQueue()
    }
    
    
    //Main Function For Calling Data Services.
    
    func callDataService<T: Decodable>(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: String]? = nil, postData: NetworkLayerEncodable?, responseClass: T.Type, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failure URL Encoding")
            return }
        guard let url = URL(string: encodedURL) else {
            print("Failure Creating URL Object")
            return }
        
        
        //Constructing URL Request.
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        urlRequest.httpMethod = method.rawValue
        if let httpHeaders = headers {
            urlRequest.allHTTPHeaderFields = httpHeaders
        }
        if let body = postData {
            do{
                let jsonObj = try body.toJSONData()
                urlRequest.httpBody = jsonObj
            } catch {
                failure(error)
                return
            }
        }
        
        
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
                if 200..<300 ~= httpResponse.statusCode {
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
    
    
    //Main Function For Calling Upload Services.
    
    func callUploadService<T: Decodable>(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: String]? = nil, postData: Data? = nil, responseClass: T.Type, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("Failure URL Encoding")
            return }
        guard let url = URL(string: encodedURL) else {
            print("Failure Creating URL Object")
            return }
        
        
        //Constructing URL Request.
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        urlRequest.httpMethod = method.rawValue
        if let httpHeaders = headers {
            urlRequest.allHTTPHeaderFields = httpHeaders
        }
        
        
        //Constrcuting URL Session.
        
        let urlSesssion = URLSession.init(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        
        
        //Constructing Upload Task.
        
        let uploadTask = urlSesssion.uploadTask(with: urlRequest, from: postData){data, urlResponse, error in
            
            
            //Handling Error Case.
            
            if let err = error {
                failure(err)
                return
            }
            
            
            //Checking For Success Response.
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                if 200..<300 ~= httpResponse.statusCode {
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
        
        uploadTask.resume()
    }
    
    
    //Main Function For Calling Download Services.
    
    func callDownloadService(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: String]? = nil, postData: NetworkLayerEncodable?, destinationURL: URL, success: @escaping SuccessBlockWithoutObject, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("Failure URL Encoding")
            return }
        guard let url = URL(string: encodedURL) else {
            print("Failure Creating URL Object")
            return }
        
        
        //Constructing URL Request.
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        urlRequest.httpMethod = method.rawValue
        if let httpHeaders = headers {
            urlRequest.allHTTPHeaderFields = httpHeaders
        }
        if let body = postData {
            do{
                let jsonObj = try body.toJSONData()
                urlRequest.httpBody = jsonObj
            } catch {
                failure(error)
                return
            }
        }
        
        
        //Constrcuting URL Session.
        
        let urlSesssion = URLSession.init(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        
        
        //Constructing Download Task.
        
        let uploadTask = urlSesssion.downloadTask(with: urlRequest){url, urlResponse, error in

            
            //Handling Error Case.
            
            if let err = error {
                failure(err)
                return
            }
            
            
            //Checking For Success Response.
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                if 200..<300 ~= httpResponse.statusCode {
                    guard let localURL = url else {
                        print("URL Path not exist")
                        return
                    }
                    
                    
                    //Move to the destination URL.
                    
                    do {
                        try FileManager.default.moveItem(at: localURL, to: destinationURL)
                        success()
                    } catch {
                        failure(error)
                    }
                }
            }
        }
        
        
        //Start The Task.
        
        uploadTask.resume()
    }
}
