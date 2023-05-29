//
//  StatRequest.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

struct StatRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case event = "event"
        case data = "data"
    }
    let event: String
    let data: String
}
