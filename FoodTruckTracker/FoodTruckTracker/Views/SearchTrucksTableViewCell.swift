//
//  SearchTrucksTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/9/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class SearchTrucksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var favoriteTruckImageView: UIImageView!
    var isCellSelected: Bool = false  {
        didSet {
            updateViews()
        }
    }
    var truck: TruckRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let truck = truck else { return }
        truckNameLabel.text = truck.truckName
        favoriteTruckImageView.image = isCellSelected ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
}
