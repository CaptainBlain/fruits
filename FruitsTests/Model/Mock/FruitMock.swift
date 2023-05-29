//
//  FruitMock.swift
//  FruitsTests
//
//  Created by Blain Ellis on 28/05/2023.
//

import Foundation
@testable import Fruits

class FruitMock {
    
    static func mock(type: String = "",
                     price: Int = 0,
                     weight: Int = 0) -> Fruit {
        return Fruit(type: type, price: price, weight: weight)
    }
    
    static var singleFruit: Fruit {
        return FruitMock.mock(type: "apple", price: 149, weight: 120)
    }
    
    static var multipleFruit: [Fruit] {
        return [FruitMock.mock(type: "apple", price: 149, weight: 120),
                FruitMock.mock(type: "banana", price: 129, weight: 80),
                FruitMock.mock(type: "orange", price: 199, weight: 150)]
    }
    
}
