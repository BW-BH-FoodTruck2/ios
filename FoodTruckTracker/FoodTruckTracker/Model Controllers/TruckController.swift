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
    let apiController = APIController()

    func getAllTrucks(with bearer: Bearer, for vendorID: Int, completion: @escaping ([TruckRepresentation]?, Error?) -> ()) {
        apiController.fetchAllTrucks(bearer: bearer) { trucks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let trucks = trucks else { return }
            let filteredTrucks = trucks.filter { $0.operatorID == vendorID }
            completion(filteredTrucks, nil)
        }
    }
    
    func addTruck(with bearer: Bearer, name: String, imageURL: String, cuisineType: String, operatorId: Int, completion: @escaping (Error?) -> ()) {
        let truck = TruckRepresentation(truckName: name, cuisineType: cuisineType, operatorID: operatorId, imageURL: imageURL)
        apiController.addTruck(truck: truck, with: bearer) { error in
            if let error = error {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func updateTruck(with bearer: Bearer, truck: TruckRepresentation, completion: @escaping (Error?) -> ()) {
        apiController.updateTruck(truck: truck, with: bearer) { error in
            if let error = error {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func deleteTruck(with bearer: Bearer, truck: TruckRepresentation, completion: @escaping (Error?) -> ()) {
        apiController.deleteTruck(truck, with: bearer) { error in
            if let error = error {
                completion(error)
            }
            
            completion(nil)
        }
    }
}
