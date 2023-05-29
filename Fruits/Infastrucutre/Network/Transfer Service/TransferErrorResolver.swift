//
//  TransferErrorResolver.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

public protocol TransferErrorResolver {
    func resolve(error: NetworkServiceError) -> Error
}

// MARK: - Error Resolver
public class DefaultTransferErrorResolver: TransferErrorResolver {
    public init() { }
    public func resolve(error: NetworkServiceError) -> Error {
        return error
    }
    
}
