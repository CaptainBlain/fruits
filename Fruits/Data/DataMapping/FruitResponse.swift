//
//  FruitResponse.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

struct FruitResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case fruit
    }
    let fruit: [FruitItemResponse]
}

struct FruitItemResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case price
        case weight
    }
    let type: String
    let price: Int
    let weight: Int
}
