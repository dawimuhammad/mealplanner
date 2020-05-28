//
//  ShoppingList+Extension.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingList {
    static func fetchQuery(viewContext: NSManagedObjectContext, tag: String) -> [ShoppingList] {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        request.predicate = NSPredicate(format: "shopping_tag == %@", tag)
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func fetchDataWithKey(viewContext: NSManagedObjectContext, tag: String) -> ShoppingList? {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        request.predicate = NSPredicate(format: "shopping_tag == %@", tag)
        let result = try? viewContext.fetch(request)
        if let res = result {
            if (res.count > 0) {
                return res[0]
            } else {
                return nil
            }
        }
        return nil
    }
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [ShoppingList] {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(ShoppingList.shopping_tag), ascending: true)
        request.sortDescriptors = [sort]
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func save(viewContext: NSManagedObjectContext, tag: String) -> ShoppingList? {
        let shoppingList = ShoppingList(context: viewContext)
        shoppingList.shopping_tag = tag
        do {
            try viewContext.save()
            return shoppingList
        } catch {
            return nil
        }
    }
    
    static func addShoppingItem(viewContext: NSManagedObjectContext, instance: ShoppingList, shoppingItem: ShoppingItem) -> ShoppingList? {
        instance.addToShopping_item(shoppingItem)
        do {
            try viewContext.save()
            return instance
        } catch {
            return nil
        }
    }
        
    static func deleteAll(viewContext: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? viewContext.execute(deleteRequest)
    }
    
    static func updateComplete(viewContext: NSManagedObjectContext, shoppingList: LocalShoppingList, isComplete: Bool ) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
        request.predicate = NSPredicate(format: "shopping_tag == %@", shoppingList.shopping_tag as NSString)
        
        do {
            let result = try viewContext.fetch(request)

            if (result.count > 0) {
                let objectUpdate = result[0] as! NSManagedObject
                objectUpdate.setValue(isComplete, forKey: "is_complete")
                
                do {
                    try viewContext.save()
                } catch {
                    print("Failed on updating the new complete state")
                }
            } else {
                print("Failed to update shopping list")
            }
        } catch {
            print("Failed to find shopping list on update")
        }
    }

    static func deleteShoppingListByPlan(viewContext: NSManagedObjectContext, plan: Plan) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
        request.predicate = NSPredicate(format: "plan_date == %@ && recipe_id == %@", plan.plan_date as! NSDate, plan.recipe_id as! NSString)
        do {
            let result = try viewContext.fetch(request)
            if (result.count > 0) {
                if let deletePlan: Plan = result[0] as! Plan {
                    viewContext.delete(deletePlan)
                    try viewContext.save()
                    print("delete plan success")
                }
            } else {
                print("Cannot delete plan")
            }
        } catch {
            print("Cannot delete plan")
        }
    }
}
