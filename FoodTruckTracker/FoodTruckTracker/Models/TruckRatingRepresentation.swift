//
//  TruckRatingRepresentation.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class TruckRatingRepresentation: Codable {
    var truckID: Int
    var rating: Int
    
    init(truckID: Int, rating: Int) {
        self.truckID = truckID
        self.rating = rating
    }
}
