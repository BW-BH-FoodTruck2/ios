//
//  CoreDataStack.swift
//  FoodTruckTracker
//
//  Created by Percy Ngan on 1/6/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

	static let shared = CoreDataStack()

	let container: NSPersistentContainer = {

		let container = NSPersistentContainer(name: "FoodTruck" as String)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
			}
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
		return container
	}()

	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
}
