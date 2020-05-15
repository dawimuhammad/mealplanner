//
//  ShoppingItem+Extension.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingItem {
    
    static func fetchQuery(viewContext: NSManagedObjectContext, attrName: String) -> [ShoppingItem] {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [ShoppingItem] {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func save(viewContext: NSManagedObjectContext, name: String, qty: Float, unit: String) -> ShoppingItem? {
        let shoppingItem = ShoppingItem(context: viewContext)
        shoppingItem.item_name = name
        shoppingItem.item_qty = qty
        shoppingItem.item_unit = unit
        do {
            try viewContext.save()
            return shoppingItem
        } catch {
            return nil
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? viewContext.execute(deleteRequest)
    }
}
