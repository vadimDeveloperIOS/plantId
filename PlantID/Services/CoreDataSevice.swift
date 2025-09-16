//
//  CoreDataSevice.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 2.07.25.
//

import Foundation
import CoreData
import UIKit

final class CoreDataSevice {

    // MARK: – Синглтон
    static let shared = CoreDataSevice()

    // MARK: – Контейнер и контекст
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext { container.viewContext }

    private init() {
        container = NSPersistentContainer(name: "PlantID")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("CoreData store failed to load: \(error)")
            }
        }
    }
    
    func fetchCarePlans(with request: NSFetchRequest<PlantInfo> = PlantInfo.fetchRequest()) throws -> [PlantInfo]  {
        do {
            let plants = try context.fetch(request)
            print("✅ ПОЛУЧЕНЫ ДАННЫЕ ( \(plants.count) -  PlantInfo ) from Core Data")
            return plants
        }
        catch {
            print("🛑 Failed to fetch PlantInfo:", error)
            throw error
        }
    }
    
    func createPlantInfo() -> PlantInfo {
        let plant = PlantInfo(context: context)
        return plant
    }
    
    func fetchPlantInfo(id: UUID) throws -> PlantInfo? {
        let request: NSFetchRequest<PlantInfo> = PlantInfo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let plants = try context.fetch(request)
            print("✅ ПОЛУЧЕНЫ ДАННЫЕ ( \(plants.count) -  PlantInfo ) from Core Data")
            return plants.first
        }
        catch {
            print("🛑 🛑 🛑 \(#function) - данные не получены ")
            return nil
        }
    }
    
    // MARK: Diary
    
    func getGrowthDiaries(
        with request: NSFetchRequest<GrowthDiary> = GrowthDiary.fetchRequest())
    throws -> [GrowthDiary] {
        
        do {
            let stories = try context.fetch(request)
            print("✅ [CoreDataSevice] получены данные дневников:\n - количество \(stories.count) \n; *")
            
            return stories
        }
        catch {
            print("🛑 [CoreDataSevice] Failed to fetch GrowthDiary:", error)
            print("***")
            throw error
        }
    }
    
    func createGrowthDiary() -> PlantInfo {
        let plant = PlantInfo(context: context)
        return plant
    }
    
    // MARK: SAVE
    
    func saveData() throws {
        guard context.hasChanges else {
            print("ℹ️ No changes in context, nothing to save")
            return
        }
        do {
            try context.save()
            print("✅ Core Data context saved successfully")
        }
        catch {
            print("🛑 Failed to save Core Data context:", error)
            throw error
        }
    }
}
