//
//  FoodTruckTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

protocol ShowTruckOnMap {
	func truckWasSelected(_ truck: TruckRepresentation)
}

class FoodTruckTableViewCell: UITableViewCell {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
	@IBOutlet weak var foodTruckImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
	var truck: TruckRepresentation? {
		didSet {
			updateViews()
		}
	}
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Setup
	private func updateViews() {
        guard let truck = truck else { return }
        
        nameLabel.text = truck.truckName
        cuisineTypeLabel.text = truck.cuisineType
    }
}
