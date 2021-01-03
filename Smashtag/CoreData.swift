//
//  CoreData.swift
//  Smashtag
//
//  Created by Chien on 2017/7/6.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import CoreData

class CoreData {

    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: Fetch From Core Data
    func fetchCoreData() -> [Tag] {
        do {
            return try self.context.fetch(Tag.fetchRequest()).sorted(by: { $0.time > $1.time } ) // 根據時間排序
        } catch {
            print("Fetch core data fail")
            return []
        }
    }

    // MARK: Save To Core Data
    func saveCoreData(with thisTag: String) {
        self.deleteCoreData(with: thisTag) // 有相同的話先刪除

        let tag: Tag = Tag(context: self.context)
        tag.name = thisTag
        tag.time = Double(Date().timeIntervalSince1970)
        self.appDelegate.saveContext()
    }

    // MARK: Delete Single Item From Core Data
    func deleteCoreData(with thisTag: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        fetch.predicate = NSPredicate(format: "name == %@", thisTag)

        do {
            let fetchResult = try self.context.fetch(fetch)
            for deleteTag in fetchResult {
                guard let deleteObject = deleteTag as? NSManagedObject else { return } // 轉型 Any -> NSManagedObject
                self.context.delete(deleteObject)
                self.appDelegate.saveContext()
            }
        } catch {
            print("Delete core data fail : \(thisTag)")
        }
    }

    // MARK: Delete All Items From Core Data
    func deleteCoreDataAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Tag.fetchRequest())
        
        do {
            try self.context.execute(deleteRequest)
            self.appDelegate.saveContext()
        } catch {
            print("Delete all core data fail")
        }
    }
}
