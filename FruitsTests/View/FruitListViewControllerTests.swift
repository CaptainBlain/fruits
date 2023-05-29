//
//  FruitListViewControllerTests.swift
//  FruitsTests
//
//  Created by Blain Ellis on 28/05/2023.
//

import XCTest
@testable import Fruits

class FruitListViewControllerTests: XCTestCase {
    
    private enum NetworkControllerError: Error {
        case someError
    }
    
    private class NetworkControllerMock: NetworkController {
        
        var expectation: XCTestExpectation?
        var error: Error?
        var fruit = [Fruit]()
        
        func getFruits(completion: @escaping (Result<[Fruits.Fruit], Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
            } else {
                print("NetworkControllerMock: \( fruit.count)")
                completion(.success(fruit))
            }
            expectation?.fulfill()
        }
        
        func submitStatReport(stats: Fruits.Stats, completion: @escaping (Result<Bool, Error>) -> Void) {
            
        }
        
    }
    
    private func getFruitListViewModel(networkController: NetworkController) -> DefaultFruitListViewModel {
        return DefaultFruitListViewModel(networkController: networkController)
    }
    
    func test_whenNetworkControllerRequestsFruit_thenViewModelContainsFruit() {
        
        let networkControllerMock = NetworkControllerMock()
        let expectation = self.expectation(description: "request fruit")
        expectation.expectedFulfillmentCount = 1
        networkControllerMock.expectation = expectation
        networkControllerMock.fruit = FruitMock.multipleFruit
        
        let viewModel = getFruitListViewModel(networkController: networkControllerMock)
        viewModel.requestFruit()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.fruit.value.count, 3)
    }
    
    func test_whenNetworkControllerRequestsFruitFails_thenViewModelContainsError() {
        
        let networkControllerMock = NetworkControllerMock()
        let expectation = self.expectation(description: "request fruit error")
        expectation.expectedFulfillmentCount = 1
        networkControllerMock.expectation = expectation
        networkControllerMock.error = NetworkControllerError.someError
        
        let viewModel = getFruitListViewModel(networkController: networkControllerMock)
        viewModel.requestFruit()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
}
