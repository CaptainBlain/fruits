//
//  ViewController.swift
//  Fruits
//
//  Created by Blain Ellis on 26/05/2023.
//

import UIKit

class FruitListViewController: UITableViewController {
    
    public var viewModel: FruitListViewModel!
    
    var networkTimer = RunningTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let actions = FruitListViewModelActions(showFruit: show)
        viewModel = AppDIContainer().makeFruitListSceneDIContainer().makeFruitListViewModel(actions: actions)
        
        bind(to: viewModel)
        
        viewModel.requestFruit()
    }

    private func bind(to viewModel: FruitListViewModel) {
        viewModel.fruit.observe(on: self) { [weak self] _ in self?.updateTableView() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.handleError($0) }
    }
    
    private func updateTableView() {
        tableView.refreshControl!.endRefreshing()
        tableView.reloadData()
    }
    
    private func updateLoading(_ loading: FruitListViewModelLoading?) {
        switch loading {
        case .loading:
            networkTimer.start()
            break
        case .finished:
            let time = networkTimer.stop()
            viewModel.send(stats: Stats(event: Event.load, data: String(describing: "\(time)")))
            break
        case .none:
            break
        }
    }

}

//MARK: Actions
extension FruitListViewController {
    
    func show(fruit: Fruit) {
        DisplayTimer.shared.start()
        performSegue(withIdentifier: String(describing: FruitItemViewController.self), sender: fruit)
    }
    
}

//MARK: TableView Datasource
extension FruitListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fruit.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fruit = viewModel.fruit.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FruitListTableViewCell.self), for: indexPath) as! FruitListTableViewCell
        cell.titleLabel.text = fruit.type
        return cell
    }
}

//MARK: TableView Delegate
extension FruitListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fruit = viewModel.fruit.value[indexPath.row]
        viewModel.didSelect(fruit: fruit)
    }
}

//MARK: TableView RefreshControl
extension FruitListViewController {
    
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        viewModel.requestFruit()
    }
}

//MARK: Error Handling
extension FruitListViewController: Alertable {
    
    private func handleError(_ error: Error?) {
        updateTableView()
        if let error = error {
            let neserror = (error as NSError)
            showError("Error", neserror.getFailureReason(), neserror.getSuggestion())
            viewModel.send(stats: Stats(event: Event.error, data: neserror.getDebugData()))
        }
    }
}

//MARK: Navigation
extension FruitListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == String(describing: FruitItemViewController.self),
           let navigationController = segue.destination as? UINavigationController,
           let destinationVC =  navigationController.viewControllers[0] as? FruitItemViewController {
            guard let fruit = sender as? Fruit else { return }
            destinationVC.fruit = fruit
        }
    }
}
