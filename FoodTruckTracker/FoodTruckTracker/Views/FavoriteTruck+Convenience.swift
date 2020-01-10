//
//  FavoriteTruck+Convenience.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/9/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import CoreData
import Foundation

extension FavoriteTruck {
    var favoriteTruckRepresentation: FavoriteTruckRepresentation? {
        return FavoriteTruckRepresentation(dinerID: Int(dinerID), truckID: Int(truckID))
    }
    
    @discardableResult convenience init(dinerID: Int64, truckID: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.dinerID = dinerID
        self.truckID = truckID
    }
    
    @discardableResult convenience init?(favoriteTruckRepresentation: FavoriteTruckRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(dinerID: Int64(favoriteTruckRepresentation.dinerID), truckID: Int64(favoriteTruckRepresentation.truckID), context: context)
    }
}
