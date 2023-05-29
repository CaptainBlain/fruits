//
//  NetworkCancellable.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }
