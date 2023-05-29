//
//  FruitItemSceneDIContainer.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

class FruitItemSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeNetworkController() -> NetworkController {
        return DefaultNetworkController(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeFruitItemViewModel() -> FruitItemViewModel {
        return DefaultFruitItemViewModel(networkController: makeNetworkController())
    }
        
}
