//
//  NetworkSessionManagerMock.swift
//  FruitsTests
//
//  Created by Blain Ellis on 28/05/2023.
//

import XCTest
@testable import Fruits

struct NetworkSessionManagerMock: NetworkSessionDataManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSessionDataTask()
    }
}
