//
//  CuisineType.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/8/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

enum CuisineType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case chinese = "Chinese"
    case waffles = "Waffles"
    case seaFood = "Sea Food"
    case burgers = "Burgers"
    case pizza = "Pizza"
    case wings = "Wings"
    case thai = "Thai"
}
