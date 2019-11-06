//
//  NetworkLayer.swift
//  NetworkLayer
//
//  Created by Abdelrahman Mahmoud on 10/7/19.
//  Copyright © 2019 AbdEl-Rahman Mahmoud. All rights reserved.
//

import Foundation


//Representation of Success&Failure Blocks.

typealias SuccessBlock<T: Decodable> = (T) -> Void
typealias FailureBlock = (Error) -> Void


//Main Class For Network Operations.

class NetworkLayer: NSObject, URLSessionDelegate {
    
    
    //Shared Instance For Universal Use.
    
    static let shared: NetworkLayer = NetworkLayer()
    
    
    //Delegate Queue.
    
    let delegateQueue: OperationQueue
    
    
    //Private Initializer.
    
    private override init(){
        delegateQueue = OperationQueue()
    }
    
    
    //Main Function For Calling Data Services.
    
    func callDataService<T: Decodable, S: Encodable>(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: String]? = nil, postData: S? = nil, success: @escaping SuccessBlock<T>, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: encodedURL) else { return }
        
        
        //Constructing URL Request.
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        urlRequest.httpMethod = method.rawValue
        if let httpHeaders = headers {
            urlRequest.allHTTPHeaderFields = httpHeaders
        }
        if let body = postData {
            do{
                let jsonObj = try JSONEncoder().encode(body)
                urlRequest.httpBody = jsonObj
            } catch {
                failure(error)
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
    
    
    //Main Function For Calling Upload Services.
    
    func callUploadService<T: Decodable>(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: String]? = nil, postData: Data? = nil, success: @escaping SuccessBlock<T>, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: encodedURL) else { return }
        
        
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
        
        uploadTask.resume()
    }
    
    
    //Main Function For Calling Download Services.
    
    func callDownloadService<T: Decodable>(urlPath: String, method: HTTPMethod, timeOutInterval: TimeInterval, headers: [String: String]? = nil, destinationURL: URL, success: @escaping SuccessBlock<T>, failure: @escaping FailureBlock) {
        
        
        //URL Encoding.
        
        guard let encodedURL = urlPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: encodedURL) else { return }
        
        
        //Constructing URL Request.
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        urlRequest.httpMethod = method.rawValue
        if let httpHeaders = headers {
            urlRequest.allHTTPHeaderFields = httpHeaders
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
                if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                    guard let localURL = url else {
                        return
                    }
                    
                    
                    //Move to the destination URL.
                    
                    do {
                        try FileManager.default.moveItem(at: localURL, to: destinationURL)
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
