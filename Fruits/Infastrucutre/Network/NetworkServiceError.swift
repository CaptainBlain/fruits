//
//  NetworkServiceError.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

public enum NetworkServiceError: Error {
    case error(statusCode: Int, message: String, description: String?, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

extension NetworkServiceError {
    
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _, _, _):
            return code == codeError
        default: return false
        }
    }
    
}
