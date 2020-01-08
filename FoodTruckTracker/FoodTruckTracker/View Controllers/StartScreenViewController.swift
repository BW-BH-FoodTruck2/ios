//
//  StartScreenViewController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit
import CoreData

class StartScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addTruckBarButtonItem: UIBarButtonItem!

    let vendorController = VendorController()

		lazy var fetch: NSFetchedResultsController<Vendor> = {

			let request: NSFetchRequest<Vendor> = Vendor.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]

			let frc = NSFetchedResultsController(fetchRequest: request,
												 managedObjectContext: CoreDataStack.shared.mainContext,
												 sectionNameKeyPath: "username",
												 cacheName: nil)
			frc.delegate = self
			do {
				try frc.performFetch()
			} catch {
				fatalError("Error performing fetch for frc: \(error)")
			}
			return frc
		}()

		override func viewDidLoad() {
			super.viewDidLoad()

			tableView.delegate = self
			tableView.dataSource = self

			setColors()
			setupViews()
		}

		override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			setupViews()
		}

		override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
		}

		func setColors() {


		}

		// Setup interface
		private func setupViews() {

		}


		// MARK: - Table view data source

		private func checkForBearerToken() {
			if vendorController.token == nil {
				performSegue(withIdentifier: "LoginModalSegue", sender: self)
			}
		}

		func numberOfSections(in tableView: UITableView) -> Int {

			return fetch.sections?.count ?? 1
		}

		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

			return fetch.sections?[section].numberOfObjects ?? 0
		}

		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCell", for: indexPath) as? FoodTruckTableViewCell else { return UITableViewCell() }

			return cell
		}

		func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
			if editingStyle == .delete {

			}
		}
	}

	extension StartScreenViewController: NSFetchedResultsControllerDelegate {

		func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			tableView.beginUpdates()
		}

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			tableView.endUpdates()
		}

		func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
						didChange anObject: Any,
						at indexPath: IndexPath?,
						for type: NSFetchedResultsChangeType,
						newIndexPath: IndexPath?) {

			switch type {
			case .insert:
				guard let newIndexPath = newIndexPath else { return }
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			case .delete:
				guard let indexPath = indexPath else { return }
				tableView.deleteRows(at: [indexPath], with: .automatic)
			case .move:
				guard let newIndexPath = newIndexPath,
					let indexPath = indexPath else { return }
				tableView.moveRow(at: indexPath, to: newIndexPath)
			case .update:
				guard let indexPath = indexPath else { return }
				tableView.reloadRows(at: [indexPath], with: .automatic)
			@unknown default:
				return
			}
		}

		func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
						didChange sectionInfo: NSFetchedResultsSectionInfo,
						atSectionIndex sectionIndex: Int,
						for type: NSFetchedResultsChangeType) {

			let set = IndexSet(integer: sectionIndex)
			switch type {
			case .insert:
				tableView.insertSections(set, with: .automatic)
			case .delete:
				tableView.deleteSections(set, with: .automatic)
			default:
				return
			}
		}
	}
