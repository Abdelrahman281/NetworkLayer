//
//  NetworkLayerEncodable.swift
//  NetworkLayer
//
//  Created by Abdelrahman Mahmoud on 12/9/19.
//  Copyright © 2019 Abdelrahman Mahmoud. All rights reserved.
//

import Foundation


//Custom protocol for objects encoding.

protocol NetworkLayerEncodable: Encodable {
    func toJSONData() throws ->  Data
}

extension NetworkLayerEncodable {
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
