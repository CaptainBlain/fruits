//
//  RunningTimer.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

import CoreFoundation
// Usage:    var timer = RunningTimer.init()
// Start:    timer.start() to restart the timer
// Stop:     timer.stop() returns the time and stops the timer
// Duration: timer.duration returns the time
// May also be used with print(" \(timer) ")

struct RunningTimer: CustomStringConvertible {
    var begin:CFAbsoluteTime
    var end:CFAbsoluteTime
    
    init() {
        begin = CFAbsoluteTimeGetCurrent()
        end = 0
    }

    mutating func start() {
        begin = CFAbsoluteTimeGetCurrent()
        end = 0
    }

    mutating func stop() -> Double {
        if (end == 0) { end = CFAbsoluteTimeGetCurrent() }
        return Double(end - begin)
    }

    var duration:CFAbsoluteTime {
        get {
            if (end == 0) { return CFAbsoluteTimeGetCurrent() - begin }
            else { return end - begin }
        }
    }

    var description:String {
         let time = duration
         if (time > 100) {return " \(time/60) min"}
         else if (time < 1e-6) {return " \(time*1e9) ns"}
         else if (time < 1e-3) {return " \(time*1e6) µs"}
         else if (time < 1) {return " \(time*1000) ms"}
         else {return " \(time) s"}
    }
}
