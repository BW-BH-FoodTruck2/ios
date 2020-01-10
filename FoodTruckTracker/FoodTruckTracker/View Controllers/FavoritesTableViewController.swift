//
//  FavoritesTableViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/9/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import CoreData
import UIKit

class FavoritesTableViewController: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<FavoriteTruck> = {
        let fetchRequest: NSFetchRequest<FavoriteTruck> = FavoriteTruck.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dinerID", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    var diner: ConsumerLogin?
    let apiController = APIController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let diner = diner, let bearer = diner.bearer else { return }
        apiController.fetchFavorites(for: diner, with: bearer) { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diner = diner, let cell = tableView.dequeueReusableCell(withIdentifier: Cells.favoritesCell, for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        cell.diner = diner
        cell.favoriteTruck = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
}

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [fromIndexPath], with: .automatic)
            tableView.insertRows(at: [toIndexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
