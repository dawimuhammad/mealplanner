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
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [Plan] {
        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result ?? []
    }
    
    static func save(viewContext: NSManagedObjectContext, date: Date, recipeId: String, recipeName: String, recipePhoto: String) -> Plan? {
        let plan = Plan(context: viewContext)
        plan.plan_date = date
        plan.recipe_id = recipeId
        plan.recipe_name = recipeName
        plan.recipe_photo = recipePhoto
        do {
            try viewContext.save()
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
}
