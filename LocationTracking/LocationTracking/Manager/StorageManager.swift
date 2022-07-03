//
//  StorageManager.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/3/22.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

final class StorageManager {

    static let shared = StorageManager()

    private init() {}
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                #if DEBUG
                let nSError = error as NSError
                fatalError("Unresolved error \(nSError), \(nSError.userInfo)")
                #endif
            }
        }
    }
    
    func save(entityName: String, predicate: NSPredicate? = nil, handle: (NSManagedObject) throws -> Void) throws {
        let managedContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        if let object = try managedContext.fetch(fetchRequest).first as? NSManagedObject {
            try handle(object)
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
                fatalError("Entity is not valid")
            }
            let object = NSManagedObject(entity: entity, insertInto: managedContext)
            try handle(object)
        }
        try managedContext.save()
    }
    
    func fetchAll<T>(entityName: String, predicate: NSPredicate? = nil, handle: (NSManagedObject) throws -> T) throws -> [T] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        return try managedContext.fetch(fetchRequest).map(handle)
    }
}

// MARK: - Locations
extension StorageManager {
    
    func save(_ location: Location) throws {
        try save(entityName: Config.entityName, predicate: NSPredicate(format: "lat == %lf AND lng == %lf", location.lat, location.lng)) { object in
            object["lat"] = location.lat
            object["lng"] = location.lng
            object["des"] = location.description
        }
    }

    func fetchAllLocations() throws -> [Location] {
        return try fetchAll(entityName: Config.entityName) { object in
            let lat: Double = (object["lat"] ?? 0)
            let lng: Double = (object["lng"] ?? 0)
            let description: String = (object["des"] ?? "")
            return Location(lat: lat, lng: lng, description: description)
        }
    }
}

// MARK: - Config
extension StorageManager {

    struct Config {
        static let entityName = "LocationEntity"
    }
}
