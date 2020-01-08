//
//  MeunItemRepresentation.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class MenuItemRepresentation: Codable {
    var itemName: String
    var itemDescription: String?
    var itemPrice: Double
    
    init(itemName: String, itemDescription: String?, itemPrice: Double) {
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemPrice = itemPrice
    }
}
