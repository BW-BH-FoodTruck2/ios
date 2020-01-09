//
//  StartScreenViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit
import CoreData

class StartScreenViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTruckBarButtonItem: UIBarButtonItem!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var vendor: VendorLogin?
    var consumer: ConsumerLogin?
    let truckController = TruckController.shared
    var trucks = [TruckRepresentation]()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let _ = vendor {
            tabBarController?.viewControllers?.removeLast()
        }
        
        if let _ = consumer {
            tabBarController?.viewControllers?.removeFirst()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private
    private func setupViews() {
        guard let vendor = vendor, let bearer = vendor.bearer, let id = vendor.id else { return }
        truckController.getAllTrucks(with: bearer, for: id) { [weak self] trucks, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            guard let trucks = trucks else { return }
            self.trucks = trucks
            self.tableView.reloadData()
        }
    }
    
    private func showAlert(title: String, message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.showAddTruckSegue:
            guard let navController = segue.destination as? UINavigationController, let addTruckVC = navController.viewControllers.first as? AddTruckViewController else { return }
            addTruckVC.vendor = vendor
        case Segues.showEditTruckSegue:
            guard let navController = segue.destination as? UINavigationController,
                let addTruckVC = navController.viewControllers.first as? AddTruckViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            addTruckVC.vendor = vendor
            addTruckVC.truck = trucks[indexPath.row]
        default:
            break
        }
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - TableView DataSource and Delegate
extension StartScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trucks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCell", for: indexPath) as? FoodTruckTableViewCell else { return UITableViewCell() }
        let truck = trucks[indexPath.row]
        cell.truck = truck
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let vendor = vendor, let bearer = vendor.bearer else { return }
            let truck = trucks[indexPath.row]
            truckController.deleteTruck(with: bearer, truck: truck) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                self.trucks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
