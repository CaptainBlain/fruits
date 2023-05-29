//
//  NetworkDataService.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

public protocol NetworkDataService {
    typealias CompletionHandler = (Result<Data?, NetworkServiceError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

// MARK: - Implementation

public final class DefaultNetworkDataService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionDataManager

    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionDataManager = DefaultNetworkSessionDataManager()) {
        self.sessionManager = sessionManager
        self.config = config
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {

        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkServiceError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, message: response.description, description: "", data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
    
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkServiceError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkDataService: NetworkDataService {
    
    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}
