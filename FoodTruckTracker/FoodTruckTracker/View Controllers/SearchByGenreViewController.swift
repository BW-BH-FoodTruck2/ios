//
//  SearchByGenreViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class SearchByGenreViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    let apiController = APIController()
    var consumer: ConsumerLogin?
    var trucks = [TruckRepresentation]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchGenres()
    }
    
    private func fetchGenres() {
        if let consumer = consumer, let bearer = consumer.bearer {
            apiController.fetchAllTrucks(bearer: bearer) { [weak self] trucks, error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                
                guard let trucks = trucks else { return }
                self.trucks = trucks
                self.tableView.reloadData()
            }
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
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
    }
}

extension SearchByGenreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trucks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.genreCell, for: indexPath) as? GenreTableViewCell else { return UITableViewCell() }
        let truck = trucks[indexPath.row]
        cell.truck = truck
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? GenreTableViewCell else { return }
        cell.isCellSelected.toggle()
    }
}
