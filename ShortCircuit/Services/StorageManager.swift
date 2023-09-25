//
//  StorageManager.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    
    // MARK: - CoreData Stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Player")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ playerName: String, completion: (User) -> Void) {
        let user = User(context: viewContext)
        user.name = playerName
        completion(user)
    
        
        
        
        saveContext()
    }
    
    
    
    
    func read(completion: (Result<[User], Error>) -> Void) {
        
        let fetchRequest = User.fetchRequest()
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    
    //MARK: - CoreData Saving Support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
