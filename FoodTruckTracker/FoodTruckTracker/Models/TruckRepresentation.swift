//
//  TruckRepresentation.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    var location: LocationRepresentation
    var imageOfTruck: String
    var customerAvgRating: Double
	var truckName: String
    var identifier: UUID

	init(location: LocationRepresentation = LocationRepresentation(longitute: 0.0, latitude: 0.0),
         imageOfTruck: String = "",
         customerAvgRating: Double = 0.0,
         truckName: String = "",
         identifier: UUID = UUID()) {

		self.location = location
		self.imageOfTruck = imageOfTruck
		self.customerAvgRating = customerAvgRating
		self.truckName = truckName
		self.identifier = identifier
	}
}
