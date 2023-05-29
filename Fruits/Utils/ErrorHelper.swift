//
//  ErrorHelper.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import Foundation

class ErrorHelper {
    
    static func error(code: Int, description: String, failureReason: String, recoverySuggestion: String, debugDetails: String) -> Error {
        return NSError(domain: "com.voxpopme", code: code,
                       userInfo: [NSLocalizedDescriptionKey: description,
                           NSLocalizedFailureReasonErrorKey: failureReason,
                      NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion,
                                 NSDebugDescriptionErrorKey: debugDetails])
    }
    
    
}

extension NSError {
    
    func getDescription() -> String {
        return self.localizedDescription
    }
    
    func getFailureReason() -> String {
        return self.localizedFailureReason ?? ""
    }
    
    func getSuggestion() -> String {
        return self.localizedRecoverySuggestion ?? ""
    }
    
    func getDebugData() -> String {
        return self.debugDescription
    }
}
