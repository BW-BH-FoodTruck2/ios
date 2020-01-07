//
//  VendorRepresentation.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

class VendorRepresentation: Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case username
        case password
        case email
        case ownedTrucks
        case identifier
    }

    var username: String
    var password: String
    var email: String
    var ownedTrucks: [TruckRepresentation]
    var identifier: UUID
    var bearer: Bearer?

    init(username: String, password: String, email: String, ownedTrucks: [TruckRepresentation], identifier: UUID) {
        self.username = username
        self.password = password
        self.email = email
        self.ownedTrucks = ownedTrucks
        self.identifier = identifier
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let username = try container.decode(String.self, forKey: .username)
        let password = try container.decode(String.self, forKey: .password)
        let email = try container.decode(String.self, forKey: .email)
        let trucksDict = try container.decodeIfPresent([String: TruckRepresentation].self, forKey: .ownedTrucks)
        var trucks: [TruckRepresentation] = []
        if let temp = trucksDict {
            trucks = Array(temp.values)
        }
        let identifier = try container.decode(String.self, forKey: .identifier)
        guard let id = UUID(uuidString: identifier) else { throw NSError() }

        self.username = username
        self.password = password
        self.email = email
        self.ownedTrucks = trucks
        self.identifier = id
    }

    static func == (lhs: VendorRepresentation, rhs: VendorRepresentation) -> Bool {
        return lhs.username == rhs.username &&
            lhs.password == rhs.password &&
            lhs.email == rhs.email &&
            lhs.identifier == rhs.identifier
    }
}

struct VendorLogin: Codable {
    var username: String
    var password: String
    var role: Int
}

struct VendorSignup: Codable {
    var username: String
    var password: String
    var role: Int
}

