//
//  MyAccountViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var vendor: VendorLogin? {
        didSet {
            updateViews()
        }
    }
    var consumer: ConsumerLogin? {
        didSet {
            updateViews()
        }
    }
    var staticTableViewController: StaticTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        staticTableViewController = self.children[0] as? StaticTableViewController
        staticTableViewController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.showGenreSegue:
            guard let searchByGenreVC = segue.destination as? SearchByGenreViewController else { return }
            if let consumer = consumer {
                searchByGenreVC.consumer = consumer
            }
        case Segues.showAllTrucksSegue:
            guard let searchTrucksVC = segue.destination as? SearchTrucksTableViewController else { return }
            searchTrucksVC.diner = consumer
        case Segues.showFavoritesSegue:
            guard let favoritesVC = segue.destination as? FavoritesTableViewController else { return }
            favoritesVC.diner = consumer
        default:
            break
        }
    }
    
    private func updateViews() {
        if let vendor = vendor, self.isViewLoaded {
            usernameLabel.text = vendor.username
        }
        
        if let consumer = consumer, self.isViewLoaded {
            usernameLabel.text = consumer.username
        }
    }
}

extension MyAccountViewController: StaticTableViewControllerDelegate {
    func searchTapped() {
        self.performSegue(withIdentifier: Segues.showGenreSegue, sender: self)
    }
    
    func trucksTapped() {
        self.performSegue(withIdentifier: Segues.showAllTrucksSegue, sender: self)
    }
    
    func favoritesTapped() {
        self.performSegue(withIdentifier: Segues.showFavoritesSegue, sender: self)
    }
}
