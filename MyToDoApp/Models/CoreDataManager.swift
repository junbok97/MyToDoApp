//
//  CoreDataManager.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/17.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "ToDoData"
    
    func getToDoListFromCoreData() -> [ToDoData] {
        guard let context = context else { return [] }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        guard let fetchedToDoList = try? context.fetch(request) as? [ToDoData] else { return [] }
        return fetchedToDoList
    }
    
    func saveToDoData(toDoText: String?, colorInt: Int64) {
        Task {
            guard let context = context else { return }
            let toDoData = ToDoData(context: context)
            
            toDoData.memoText = toDoText
            toDoData.date = Date()
            toDoData.color = colorInt
            
            await appDelegate?.saveContext()
        }
    }
    
    func saveToDoData2(toDoText: String?, colorInt: Int64) {
        Task {
            guard
                let context = context,
                let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context),
                let toDoData = NSManagedObject(entity: entity, insertInto: context) as? ToDoData
            else { return }
            
            toDoData.memoText = toDoText
            toDoData.date = Date()
            toDoData.color = colorInt
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    func deleteToDo(data: ToDoData) {
        Task {
            guard
                let date = data.date,
                let context = context
            else { return }
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            guard
                let fetchedToDoList = try? context.fetch(request) as? [ToDoData],
                let targetToDo = fetchedToDoList.first
            else { return }
            
            context.delete(targetToDo)
            await appDelegate?.saveContext()
        }
    }
    
    func updateToDo(newToDoData: ToDoData) {
        Task {
            guard
                let date = newToDoData.date,
                let context = context
            else { return }
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            guard
                let fetchToDoList = try? context.fetch(request) as? [ToDoData],
                var targetToDo = fetchToDoList.first
            else { return }
            
            targetToDo = newToDoData
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Update Save Error")
                    print(error)
                }
            }
        }
    }
    
}


