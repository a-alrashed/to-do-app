//
//  ToDoItem+CoreDataProperties.swift
//  the to do app
//
//  Created by Azzam R Alrashed on 31/12/2020.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var text: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoItem : Identifiable {

}
