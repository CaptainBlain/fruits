//
//  APIEndpoints.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

struct APIEndpoints {
    
    static func requestFruits() -> Endpoint<FruitResponse>  {
       
        return Endpoint(path:  "/data.json",
                        method: .get)
    }
    
    static func sendStats(request: StatRequest) -> Endpoint<StatResponse>  {
       
        return Endpoint(path:  "/stats",
                        method: .get,
                        queryParametersEncodable: request)
    }
    
}
