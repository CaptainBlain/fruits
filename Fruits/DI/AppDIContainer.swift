//
//  AppDIContainer.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master")!,
                                          headers: ["Content-Type":"application/json"])

        let apiDataNetwork = DefaultNetworkDataService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    func makeFruitListSceneDIContainer() -> FruitListSceneDIContainer {
        let dependencies = FruitListSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return FruitListSceneDIContainer(dependencies: dependencies)
    }
    
    func makeFruitItemSceneDIContainer() -> FruitItemSceneDIContainer {
        let dependencies = FruitItemSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return FruitItemSceneDIContainer(dependencies: dependencies)
    }
}
