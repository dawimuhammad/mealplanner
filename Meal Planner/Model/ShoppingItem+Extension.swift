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
        shoppingItem.item_id = UUID()
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
    
    static func addPlan(viewContext: NSManagedObjectContext, instance: ShoppingItem, plan: Plan) -> ShoppingItem? {
        do {
            instance.plan = plan
            try viewContext.save()
            return instance
        } catch {
            return nil
        }
    }
    
    static func addShopingList(viewContext: NSManagedObjectContext, instance: ShoppingItem, shopingList: ShoppingList) -> ShoppingItem? {
        do {
            instance.addToShopping_list(shopingList)
            try viewContext.save()
            return instance
        } catch {
            return nil
        }
    }
    
    static func deleteItem(viewContext: NSManagedObjectContext, item: ShoppingItem) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        request.predicate = NSPredicate(format: "item_id == %@",item.item_id as! NSUUID)
       do {
            let result = try viewContext.fetch(request)
            if (result.count > 0) {
                if let deleteItem: ShoppingItem = result[0] as? ShoppingItem {
                    viewContext.delete(deleteItem)
                    print("delete item success")
                    return true
                }
            } else {
                print("Cannot delete item")
                return false
            }
        } catch {
            print("Cannot delete item")
            return false
        }
        return false
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? viewContext.execute(deleteRequest)
    }
}
