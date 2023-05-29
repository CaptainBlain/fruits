//
//  DataTransferService.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

public protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, TransferError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
}

public final class DefaultDataTransferService {
    
    private let networkDataService: NetworkDataService
    private let errorResolver: TransferErrorResolver
    
    public init(with networkDataService: NetworkDataService,
                errorResolver: TransferErrorResolver = DefaultTransferErrorResolver()) {
        self.networkDataService = networkDataService
        self.errorResolver = errorResolver
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    public func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                              completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {

        return self.networkDataService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, TransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { return completion(result) }
            case .failure(let error):
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, TransferError> {

        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)

            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkServiceError) -> TransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkServiceError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
    
}
