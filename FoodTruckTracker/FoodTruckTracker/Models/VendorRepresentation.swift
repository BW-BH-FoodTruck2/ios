//
//  VendorRepresentation.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class VendorRepresentation: Codable, Equatable {
    
    var username: String
    var password: String
    var email: String
    var ownedTrucks: [TruckPostable]
    var id: Int
    var bearer: Bearer?

    init(username: String, password: String, email: String, ownedTrucks: [TruckPostable], id: Int) {
        self.username = username
        self.password = password
        self.email = email
        self.ownedTrucks = ownedTrucks
        self.id = id
    }

    static func == (lhs: VendorRepresentation, rhs: VendorRepresentation) -> Bool {
        return lhs.username == rhs.username &&
            lhs.password == rhs.password &&
            lhs.email == rhs.email &&
            lhs.id == rhs.id
    }
}

struct VendorLogin: Codable {
    var id: Int?
    var username: String
    var password: String
    var role: Int
    var bearer: Bearer?
}

struct VendorSignup: Codable {
    var username: String
    var password: String
    var role: Int
}

