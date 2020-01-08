//
//  TruckRepresentation.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    
    var id: Int?
    var truckName: String
    var cuisineType: String
    var operatorID: Int
    var imageURL: String?

    init(truckName: String, cuisineType: String, operatorID: Int, imageURL: String?) {
        self.truckName = truckName
        self.cuisineType = cuisineType
        self.operatorID = operatorID
        self.imageURL = imageURL
	}
}
