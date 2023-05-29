//
//  NetworkController.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

final class DefaultNetworkController {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
}

extension DefaultNetworkController: NetworkController {
    
    func getFruits( completion: @escaping (Result<[Fruit], Error>) -> Void) {
        
        let endpoint = APIEndpoints.requestFruits()
    
        self.dataTransferService.request(with: endpoint) { result in
                        
            switch result {
            case .success(let responseDTO):
                let fruits = responseDTO.fruit.map({Fruit(type: $0.type, price: $0.price, weight: $0.weight)})
                completion(.success(fruits))
            case .failure(let error):
                let message = "\(#function), line: \(#line)"
                completion(.failure(ErrorHelper.error(code: 1,
                                                      description: "Unable to get fruit",
                                                      failureReason: error.localizedDescription,
                                                      recoverySuggestion: "Please try again",
                                                      debugDetails: message)))
            }
        }
    }
    
    func submitStatReport(stats: Stats, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let statRequest = StatRequest(event: stats.event.rawValue, data: stats.data)
        let endpoint = APIEndpoints.sendStats(request: statRequest)
    
        self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let message = "\(#function), line: \(#line)"
                completion(.failure(ErrorHelper.error(code: 1,
                                                      description: "Unable to submit stats",
                                                      failureReason: error.localizedDescription,
                                                      recoverySuggestion: "",
                                                      debugDetails: message)))
            }
        }
    }
}
