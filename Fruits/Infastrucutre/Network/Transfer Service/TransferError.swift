//
//  TransferError.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

public enum TransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkServiceError)
    case resolvedNetworkFailure(Error)
}
