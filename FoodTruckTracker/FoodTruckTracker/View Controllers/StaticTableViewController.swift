//
//  StaticTableViewController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

protocol StaticTableViewControllerDelegate: class {
    func searchTapped()
    func trucksTapped()
    func favoritesTapped()
}

class StaticTableViewController: UITableViewController {
    weak var delegate: StaticTableViewControllerDelegate?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            delegate?.favoritesTapped()
        } else if indexPath.row == 1 {
            delegate?.searchTapped()
        } else if indexPath.row == 4 {
            delegate?.trucksTapped()
        }
    }
}
