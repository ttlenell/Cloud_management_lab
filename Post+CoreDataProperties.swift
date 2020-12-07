//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Tobias Classon on 2020-12-07.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var id: Int16

}
