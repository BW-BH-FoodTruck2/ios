//
//  FoodTruckTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

protocol ShowTruckOnMap {
	func truckWasSelected(_ truck: TruckPostable)
}

class FoodTruckTableViewCell: UITableViewCell {

	@IBOutlet weak var foodTruckImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var distanceAwayLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!


	var truck: TruckPostable? {
		didSet {
			updateViews()
		}
	}

	var delegate: ShowTruckOnMap?
	var distanceAway: Double?
	var address: String?

	var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        return nf
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func updateViews() {
        guard let truck = truck else { return }

        nameLabel.text = truck.truckName
        if let address = address {
            addressLabel.text = address
        } else {
            addressLabel.text = "Truck isn't around"
        }
        if let distanceAway = distanceAway,
            let num = distanceAway as? NSNumber,
            let distance = numberFormatter.string(from: num) {
            distanceAwayLabel.text = "\(distance) mi"
        } else {
            distanceAwayLabel.text = "N/A away"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
