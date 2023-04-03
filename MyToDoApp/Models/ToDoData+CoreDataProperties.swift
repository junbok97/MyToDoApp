//
//  ToDoData+CoreDataProperties.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/17.
//
//

import Foundation
import CoreData


extension ToDoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoData> {
        return NSFetchRequest<ToDoData>(entityName: "ToDoData")
    }

    @NSManaged public var color: Int64
    @NSManaged public var date: Date?
    @NSManaged public var memoText: String?
    
    var dateString: String? {
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = self.date else { return "" }
        
        return myFormatter.string(from: date)
    }

}

extension ToDoData : Identifiable {

}
