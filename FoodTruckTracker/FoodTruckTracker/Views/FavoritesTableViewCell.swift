//
//  FavoritesTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/9/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteNameLabel: UILabel!
    
    let apiController = APIController()
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        aiv.style = .large
        aiv.color = .darkGray
        return aiv
    }()
    
    var diner: ConsumerLogin?
    var favoriteTruck: FavoriteTruck? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let diner = diner, let bearer = diner.bearer, let favoriteTruck = favoriteTruck else { return }
        contentView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        activityIndicatorView.startAnimating()
        apiController.fetchTruck(for: Int(favoriteTruck.truckID), with: bearer) { [weak self] truck, error in
            guard let self = self else { return }
            if let _ = error { return }
            
            guard let truck = truck else { return }
            
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.favoriteNameLabel.text = truck.truckName
        }
    }
}
