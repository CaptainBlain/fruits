//
//  FruitsListSceneDIContainer.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

class FruitListSceneDIContainer {
    
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
    
    func makeFruitListViewModel(actions: FruitListViewModelActions?) -> FruitListViewModel {
        return DefaultFruitListViewModel(networkController: makeNetworkController(),
        actions: actions)
    }
    
}
