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
            if let vendor = vendor {
                searchByGenreVC.vendor = vendor
            }
        default:
            break
        }
    }
    
    private func updateViews() {
        if let vendor = vendor, self.isViewLoaded {
            usernameLabel.text = vendor.username
            print(vendor.bearer?.token)
        }
        
        if let consumer = consumer, self.isViewLoaded {
            usernameLabel.text = consumer.username
            print(consumer.bearer?.token)
        }
    }
}

extension MyAccountViewController: StaticTableViewControllerDelegate {
    func searchTapped() {
        self.performSegue(withIdentifier: Segues.showGenreSegue, sender: self)
    }
}
