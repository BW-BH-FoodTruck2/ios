//
//  ServerTruck.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

struct ServerTruck: Codable {
    
    var id: Int?
    var truckName: String
    var cuisineType: String
    var operatorID: Int
    var imageURL: String?

    init(id: Int?, truckName: String, cuisineType: String, operatorID: Int, imageURL: String?) {
        self.id = id
        self.truckName = truckName
        self.cuisineType = cuisineType
        self.operatorID = operatorID
        self.imageURL = imageURL
    }
}
