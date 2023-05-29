//
//  File.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import UIKit

public protocol Alertable {}
public extension Alertable where Self: UIViewController {
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func showError(_ title: String, _ reason: String, _ solution: String) {
        let errorMessage = "\n" + reason + "\n\n" + solution
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        if traitCollection.userInterfaceStyle == .dark {
            alertController.view.tintColor = UIColor.white
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
