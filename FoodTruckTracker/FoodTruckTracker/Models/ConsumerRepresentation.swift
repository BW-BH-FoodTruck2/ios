//
//  ConsumerRepresentation.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class ConsumerRepresentation: Codable, Equatable {
    
    var username: String
    var password: String
    var location: String
    var id: Int

    init(username: String, password: String, location: String, id: Int) {
        self.username = username
        self.password = password
        self.location = location
        self.id = id
    }

    static func == (lhs: ConsumerRepresentation, rhs: ConsumerRepresentation) -> Bool {
        return lhs.username == rhs.username &&
            lhs.password == rhs.password &&
            lhs.id == rhs.id
    }
}


struct ConsumerLogin: Codable { // To log in the user only needs to input a username and password
    var id: Int?
    var username: String
    var password: String
    var role: Int
    var bearer: Bearer?
}

struct ConsumerSignup: Codable { // To sign up the user needs to put in a username, password, and email
    var username: String
    var password: String
    var role: Int
    var location: String
}
