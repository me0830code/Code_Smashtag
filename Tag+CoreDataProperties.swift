//
//  Tag+CoreDataProperties.swift
//  
//
//  Created by Chien on 2017/7/4.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var time: Double?

}
