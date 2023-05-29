//
//  FruiteViewModel.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

protocol FruitItemViewModelInput {
    func set(fruit: Fruit)
    func send(stats: Stats)
}

protocol FruitItemViewModelOutput {
    var fruit: Observable<Fruit?> { get }
    var completionHandler: ((Result<Bool, Error>) -> Void)? { get }
    var error: Observable<Error?> { get }
}

protocol FruitItemViewModel: FruitItemViewModelInput, FruitItemViewModelOutput {}

class DefaultFruitItemViewModel: FruitItemViewModel {
    
    // MARK: - OUTPUT
    let fruit: Observable<Fruit?> = Observable(nil)
    var completionHandler: ((Result<Bool, Error>) -> Void)?
    var error: Observable<Error?> = Observable(nil)
    
    let networkController: NetworkController
 
    init(networkController: NetworkController) {
        self.networkController = networkController
    }
    
    func set(fruit: Fruit) {
        self.fruit.value = fruit
    }
    
    func send(stats: Stats) {
        networkController.submitStatReport(stats: stats) { result in
            self.completionHandler?(result)
        }
    }
}
