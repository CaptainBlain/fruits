//
//  FruitViewController.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import UIKit

class FruitItemViewController: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var fruit: Fruit!
    private var viewModel: FruitItemViewModel!
    // MARK: -
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewModel = AppDIContainer().makeFruitItemSceneDIContainer().makeFruitItemViewModel()
        bind(to: viewModel)
        viewModel.set(fruit: fruit)
        
        let time = DisplayTimer.shared.stop()
        viewModel.send(stats: Stats(event: Event.display, data: String(describing: "\(time)")))
    }
    
    private func bind(to viewModel: FruitItemViewModel) {
        viewModel.fruit.observe(on: self) { [weak self] in self?.updateUI($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.handleError($0) }
    }
    
    private func updateUI(_ fruit: Fruit?) {
        guard let fruit = fruit else { return }
        typeLabel.text = fruit.type
        priceLabel.text = String(describing: "£\(fruit.price)")
        weightLabel.text = String(describing: "\(fruit.weight)g")
    }
    
}

//MARK: Error Handling
extension FruitItemViewController: Alertable {
    
    private func handleError(_ error: Error?) {

        if let error = error {
            let neserror = (error as NSError)
            showError("Error", neserror.getFailureReason(), neserror.getSuggestion())
            viewModel.send(stats: Stats(event: Event.error, data: neserror.getDebugData()))
        }
    }
}
