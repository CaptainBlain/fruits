//
//  FruitListViewModel.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

struct FruitListViewModelActions {
    let showFruit: (Fruit) -> ()
}

enum FruitListViewModelLoading: String {
    case loading = "loading"
    case finished = "finished"
}

protocol FruitListViewModelInput {
    func requestFruit()
    func didSelect(fruit: Fruit)
    func send(stats: Stats)
}

protocol FruitListViewModelOutput {
    var fruit: Observable<[Fruit]> { get }
    var loading: Observable<FruitListViewModelLoading?> { get }
    var error: Observable<Error?> { get }
}

protocol FruitListViewModel: FruitListViewModelInput, FruitListViewModelOutput {}

final class DefaultFruitListViewModel: FruitListViewModel {
    
    private let networkController: NetworkController
    private let actions: FruitListViewModelActions?
    
    let fruit: Observable<[Fruit]> = Observable([])
    let loading: Observable<FruitListViewModelLoading?> = Observable(.none)
    let error: Observable<Error?> = Observable(nil)
    
    init(networkController: NetworkController,
         actions: FruitListViewModelActions? = nil) {
        self.networkController = networkController
        self.actions = actions
    }
    
    func requestFruit() {
        loading.value = .loading
        networkController.getFruits { result in
            self.loading.value = .finished
            switch (result) {
            case .success(let fruits):
                self.fruit.value = fruits
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func didSelect(fruit: Fruit) {
        actions?.showFruit(fruit)
    }
    
    func send(stats: Stats) {
        networkController.submitStatReport(stats: stats) { _ in
            
        }
    }
}
