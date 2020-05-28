//
//  Plan+Extension.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import CoreData

extension Plan {
    static func fetchQuery(viewContext: NSManagedObjectContext, attrName: String) -> [Plan] {
        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func fetchQueryAfterDate(viewContext: NSManagedObjectContext, date: Date) -> [Plan] {
        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        request.predicate = NSPredicate(format: "plan_date >= %@", Calendar.current.startOfDay(for: date) as NSDate)
        let sort = NSSortDescriptor(key: #keyPath(Plan.plan_date), ascending: true)
        request.sortDescriptors = [sort]
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func fetchQueryBeforeDate(viewContext: NSManagedObjectContext, date: Date) -> [Plan] {
        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        request.predicate = NSPredicate(format: "plan_date < %@", Calendar.current.startOfDay(for: date) as NSDate)
        let sort = NSSortDescriptor(key: #keyPath(Plan.plan_date), ascending: true)
        request.sortDescriptors = [sort]
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [Plan] {
        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func save(viewContext: NSManagedObjectContext, date: Date, recipeId: String, recipeName: String, recipePhoto: String, duration: Int16, portion: Int16) -> Plan? {
        let plan = Plan(context: viewContext)
        plan.plan_date = date
        plan.recipe_id = recipeId
        plan.recipe_name = recipeName
        plan.recipe_photo = recipePhoto
        plan.recipe_duration = duration
        plan.recipe_portion = portion
        do {
            try viewContext.save()
            print("SAVE PLAN SUCCESS")
            return plan
        } catch {
            return nil
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        let _ = try? viewContext.execute(deleteRequest)
    }
    
    static func deletePlan(viewContext: NSManagedObjectContext, plan: Plan) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        request.predicate = NSPredicate(format: "plan_date == %@ && recipe_id == %@", plan.plan_date as! NSDate, plan.recipe_id as! NSString)
        do {
            let result = try viewContext.fetch(request)
            print(result.count)
            if (result.count > 0) {
                if let deletePlan: Plan = result[0] as! Plan {
                    let deleteItems: [ShoppingItem] = deletePlan.shopping_item?.allObjects as! [ShoppingItem]
                    for item in deleteItems {
                        ShoppingItem.deleteItem(viewContext: viewContext, item: item)
                    }
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
    
    static func savePlan (viewContext: NSManagedObjectContext, date: Date, recipe: Recipe) -> Plan {
        let plan = Plan.save(viewContext: viewContext, date: date, recipeId: recipe.id!, recipeName: recipe.name!, recipePhoto: recipe.photo!, duration: Int16(recipe.duration!), portion: Int16(recipe.portion!))
        for ingredientSection in recipe.ingredientSections! {
            for ingredient in ingredientSection.ingredients! {
                for tag in ingredient.tag! {
                    let shoppingItem = ShoppingItem.save(viewContext: viewContext, name: ingredient.name!, qty: ingredient.qty!, unit: ingredient.unit!)
                    ShoppingItem.addPlan(viewContext: viewContext, instance: shoppingItem!, plan: plan!)
                    let existingTag = ShoppingList.fetchDataWithKey(viewContext: viewContext, tag: tag)
                    if existingTag != nil {
                        ShoppingList.addShoppingItem(viewContext: viewContext, instance: existingTag!, shoppingItem: shoppingItem!)
                        ShoppingItem.addShopingList(viewContext: viewContext, instance: shoppingItem!, shopingList: existingTag!)
                    } else {
                        let shoppinglist = ShoppingList.save(viewContext: viewContext, tag: tag)
                        ShoppingList.addShoppingItem(viewContext: viewContext, instance: shoppinglist!, shoppingItem: shoppingItem!)
                        ShoppingItem.addShopingList(viewContext: viewContext, instance: shoppingItem!, shopingList: shoppinglist!)
                    }
                }
            }
        }
        return plan!
    }
}
