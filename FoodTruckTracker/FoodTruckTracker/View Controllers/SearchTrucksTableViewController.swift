//
//  SearchTrucksTableViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/9/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import CoreData
import UIKit

class SearchTrucksTableViewController: UITableViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    let apiController = APIController()
    var trucks = [TruckRepresentation]() {
        didSet {
            tableView.reloadData()
        }
    }
    var diner: ConsumerLogin?
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrucks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let moc = CoreDataStack.shared.container.newBackgroundContext()
        do {
            try CoreDataStack.shared.save(context: moc)
        } catch let saveError {
            self .showAlert(title: "Error saving favorites", message: saveError.localizedDescription)
        }
    }
    
    private func fetchTrucks() {
        guard let diner = diner, let bearer = diner.bearer else { return }
        apiController.fetchAllTrucks(bearer: bearer) { [weak self] trucks, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            guard let trucks = trucks else { return }
            self.trucks = trucks
        }
    }
    
    private func showAlert(title: String, message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trucks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.searchTrucksCell, for: indexPath) as? SearchTrucksTableViewCell else { return UITableViewCell() }
        let truck  = trucks[indexPath.row]
        cell.truck = truck
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let diner = diner, let bearer = diner.bearer, let id = diner.id, let cell = tableView.cellForRow(at: indexPath) as? SearchTrucksTableViewCell else { return }
        cell.isCellSelected.toggle()
        apiController.addFavorite(truck: trucks[indexPath.row], with: id, bearer: bearer) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
