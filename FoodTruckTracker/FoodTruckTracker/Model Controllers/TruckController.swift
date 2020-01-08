//
//  TruckController.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class TruckController {

	var trucks: [TruckRepresentation] = []

	static let shared = TruckController()

	func getTrucks(with searchTerm: String?) -> [TruckRepresentation] {
		guard let searchTerm = searchTerm, !searchTerm.isEmpty else { return [] }

		let filteredNames = trucks.filter({(item: TruckRepresentation) -> Bool in
			let stringMatch = item.truckName.lowercased().range(of: searchTerm.lowercased())
			return stringMatch != nil ? true : false
		})
		return filteredNames
	}

//	func createTruck(with truckName: String, location: Location, imageOfTruck: String, identifier: UUID = UUID()) {
//        let truck = Truck(truckName: truckName, customerAvgRating: 0, location: Location(longitude: 0, latitude: 0), imageOfTruck: "")
//        put(truck: truck)
//        saveToPersistentStore()
//    }

	func refreshTrucksFromServer() {
		
	}

	func delete() {

	}

	func saveToPersistentStore() {
		
	}
}
