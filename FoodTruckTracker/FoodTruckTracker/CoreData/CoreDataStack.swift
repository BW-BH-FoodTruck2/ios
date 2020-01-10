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

		let container = NSPersistentContainer(name: "FoodTruckTracker" as String)
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
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
}
