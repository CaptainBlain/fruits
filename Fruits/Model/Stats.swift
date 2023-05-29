//
//  Event.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

struct Stats {
    let event: Event
    let data: String
}

enum Event: String {
    case load = "load"
    case display = "display"
    case error = "error"
}
