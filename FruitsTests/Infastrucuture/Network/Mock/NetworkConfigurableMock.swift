//
//  NetworkConfigurableMock.swift
//  FruitsTests
//
//  Created by Blain Ellis on 28/05/2023.
//

import XCTest
@testable import Fruits

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
