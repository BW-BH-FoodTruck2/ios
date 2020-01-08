//
//  GenreTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var genreTitleLabel: UILabel!
    var isCellSelected: Bool = false {
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
        genreTitleLabel.text = truck.cuisineType
        checkboxImageView.image = isCellSelected ? UIImage(systemName: "clear") : UIImage(systemName: "stop")
    }
}
