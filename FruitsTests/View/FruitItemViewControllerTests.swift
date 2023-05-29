//
//  FruitItemViewControllerTests.swift
//  FruitsTests
//
//  Created by Blain Ellis on 29/05/2023.
//

import XCTest
@testable import Fruits

class FruitItemViewControllerTests: XCTestCase {
    
    private enum NetworkControllerError: Error {
        case someError
    }
    
    private class NetworkControllerMock: NetworkController {
        
        var expectation: XCTestExpectation?
        var error: Error?
        
        func getFruits(completion: @escaping (Result<[Fruits.Fruit], Error>) -> Void) {
            
        }
        
        func submitStatReport(stats: Fruits.Stats, completion: @escaping (Result<Bool, Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            expectation?.fulfill()
        }
    }
    
    private func getFruitItemViewModel(networkController: NetworkController) -> DefaultFruitItemViewModel {
        return DefaultFruitItemViewModel(networkController: networkController)
    }
    
    func test_whenViewModelSetupFruit_thenViewModelFruitSet() {
        
        let networkControllerMock = NetworkControllerMock()
        let viewModel = getFruitItemViewModel(networkController: networkControllerMock)
        viewModel.set(fruit: FruitMock.singleFruit)

        XCTAssertNotNil(viewModel.fruit.value)
    }
    
    func test_whenViewModelSuccesfullySendStats_thenCompletionhandlerComplete() {
        
        let networkControllerMock = NetworkControllerMock()
        let expectation = self.expectation(description: "submit stats")
        expectation.expectedFulfillmentCount = 1
        networkControllerMock.expectation = expectation
        
        let viewModel = getFruitItemViewModel(networkController: networkControllerMock)
        viewModel.completionHandler = { result in
            if case let .success(success) = result {
                XCTAssertTrue(success)
            }
            if case .failure(_) = result {
                XCTFail("Test failed")
            }
        }
        viewModel.send(stats: StatsMock.loadData)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
