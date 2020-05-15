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
    static func fetchQuery(viewContext: NSManagedObjectContext, attrName: String) -> [ShoppingList] {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [ShoppingList] {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
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
    
    static func addPlan(viewContext: NSManagedObjectContext, instance: ShoppingList, plan: Plan) -> ShoppingList? {
        instance.addToPlan(plan)
        do {
            try viewContext.save()
            return instance
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
}
