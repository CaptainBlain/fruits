//
//  NetworkController.swift
//  Fruits
//
//  Created by Blain Ellis on 28/05/2023.
//

import Foundation

protocol NetworkController {
    
    func getFruits(completion: @escaping (Result<[Fruit], Error>) -> Void)
    func submitStatReport(stats: Stats, completion: @escaping (Result<Bool, Error>) -> Void)
    
}
