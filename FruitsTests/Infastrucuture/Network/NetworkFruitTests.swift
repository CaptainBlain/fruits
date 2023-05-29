//
//  NetworkFruitTests.swift
//  FruitsTests
//
//  Created by Blain Ellis on 28/05/2023.
//

import XCTest
@testable import Fruits


class NetworkFruitTests: XCTestCase {
    
    private enum DataTransferErrorMock: Error {
        case someError
    }
    private struct MockModel: Decodable {
        let fruit: String
    }
    
    func test_whenReceivedFruitDataInResponse_shouldDecodeToFruitResponseDTO() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should decode fruit response object")
        
        let responseData = dataFromResource(resource: "master_data")
        let networkService = DefaultNetworkDataService(config: config, sessionManager: NetworkSessionManagerMock(response: nil, data: responseData, error: nil))
     
        let sut = DefaultDataTransferService(with: networkService)
        
        //when
        _ = sut.request(with: Endpoint<FruitResponse>(path: "/data.json", method: .post)) { result in

            do {
                let object = try result.get()
                
                XCTAssertNotNil(object.fruit)
                
                let apple = object.fruit.first(where: { $0.type == "apple"})
          
                XCTAssertEqual(apple?.type, "apple")
                XCTAssertEqual(apple?.price, 149)
                XCTAssertEqual(apple?.weight, 120)
                
                expectation.fulfill()
            } catch {
                print("Error: \(error)")
                XCTFail("Failed decoding")
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenInvalidResponse_shouldNotDecodeObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should not decode mock object")
        
        let responseData = #"{"fruit": apple}"#.data(using: .utf8)
        let networkService = DefaultNetworkDataService(config: config, sessionManager: NetworkSessionManagerMock(response: nil, data: responseData, error: nil))

        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://test.endpoint.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenBadRequestReceived_shouldRethrowNetworkError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw network error")
        
        let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        let networkService = DefaultNetworkDataService(config: config, sessionManager: NetworkSessionManagerMock(response: response, data: responseData, error: DataTransferErrorMock.someError))
        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://test.endpoint.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                
                if case TransferError.networkFailure(NetworkServiceError.error(statusCode: 500, _, _, _)) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenNoDataReceived_shouldThrowNoDataError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw no data error")
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkService = DefaultNetworkDataService(config: config, sessionManager: NetworkSessionManagerMock(response: response, data: nil, error: nil))
        let sut = DefaultDataTransferService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: "http://test.endpoint.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case TransferError.noResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
