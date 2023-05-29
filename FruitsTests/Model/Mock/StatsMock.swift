//
//  StatMock.swift
//  FruitsTests
//
//  Created by Blain Ellis on 29/05/2023.
//

import Foundation
@testable import Fruits

class StatsMock {
    
    static func mock(event: Event = .load,
                     data: String = "") -> Stats {
        return Stats(event: event, data: data)
    }
    
    static var loadData: Stats {
        return StatsMock.mock(event: .load, data: "data")
    }
        
}
