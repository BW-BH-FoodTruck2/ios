//
//  CurrentTruckLocationRepresentation.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class CurrentTruckLocationRepresentation: Codable {
    var truckID: Int
    var location: String
    var departureTime: Date
    
    init(truckID: Int, location: String, departureTime: Date) {
        self.truckID = truckID
        self.location = location
        self.departureTime = departureTime
    }
}
