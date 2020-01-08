//
//  FavoriteTruckRepresentation.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class FavoriteTruckRepresentation: Codable {
    var dinerID: Int
    var truckID: Int
    
    init(dinerID: Int, truckID: Int) {
        self.dinerID = dinerID
        self.truckID = truckID
    }
}
