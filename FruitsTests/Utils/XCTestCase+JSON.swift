//
//  XCTestCase+JSON.swift
//  FruitsTests
//
//  Created by Blain Ellis on 28/05/2023.
//

import XCTest

extension XCTestCase {
    
    func dataFromResource(resource: String) -> Data? {
        
        let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json")
        let data = try? Data(contentsOf: url!)
        return data
    }
}
