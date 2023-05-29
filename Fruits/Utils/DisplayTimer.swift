//
//  DisplayTimer.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

class DisplayTimer: NSObject {
    
    static var shared: DisplayTimer = {
        struct StaticInstance {
            static let instance = DisplayTimer()
        }
        return StaticInstance.instance
    }()
    
    var timer = RunningTimer()
    
    func start() {
        timer.start()
    }
    
    func stop() -> Double {
        return timer.stop()
    }
}
