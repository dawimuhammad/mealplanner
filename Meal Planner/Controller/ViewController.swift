//
//  ViewController.swift
//  Meal Planner
//
//  Created by Haddawi on 07/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Plan.deleteAll(viewContext: getViewContext())
        ShoppingList.deleteAll(viewContext: getViewContext())
        ShoppingItem.deleteAll(viewContext: getViewContext())
        var dayComponent    = DateComponents()
        let theCalendar     = Calendar.current

        let babis: [Recipe] = categories.getRecipeByCategory(category: .babi)!
        dayComponent.day    = -1 // For removing one day (yesterday): -1
        let prevDate: Date  = theCalendar.date(byAdding: dayComponent, to: Date())!
        for babi: Recipe in babis {
            let plan = Plan.save(viewContext: getViewContext(), date: prevDate, recipeId: babi.id!, recipeName: babi.name!, recipePhoto: babi.photo!, duration: Int16(babi.duration!), portion: Int16(babi.portion!))
            for ingredientSection in babi.ingredientSections! {
                for ingredient in ingredientSection.ingredients! {
                    for tag in ingredient.tag! {
                        let shoppingItem = ShoppingItem.save(viewContext: getViewContext(), name: ingredient.name!, qty: ingredient.qty!, unit: ingredient.unit!)
                        let existingTag = ShoppingList.fetchDataWithKey(viewContext: getViewContext(), tag: tag)
                        if existingTag != nil {
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: existingTag!, shoppingItem: shoppingItem!)
                        } else {
                            let shoppinglist = ShoppingList.save(viewContext: getViewContext(), tag: tag)
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: shoppinglist!, shoppingItem: shoppingItem!)
                        }
                    }
                }
            }
        }
        
        // sample usage of categories usage
        let ayams: [Recipe] = categories.getRecipeByCategory(category: .ayam)!
        for ayam: Recipe in ayams {
            let plan = Plan.save(viewContext: getViewContext(), date: Date(), recipeId: ayam.id!, recipeName: ayam.name!, recipePhoto: ayam.photo!, duration: Int16(ayam.duration!), portion: Int16(ayam.portion!))
            for ingredientSection in ayam.ingredientSections! {
                for ingredient in ingredientSection.ingredients! {
                    for tag in ingredient.tag! {
                        let shoppingItem = ShoppingItem.save(viewContext: getViewContext(), name: ingredient.name!, qty: ingredient.qty!, unit: ingredient.unit!)
                        let existingTag = ShoppingList.fetchDataWithKey(viewContext: getViewContext(), tag: tag)
                        if existingTag != nil {
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: existingTag!, shoppingItem: shoppingItem!)
                        } else {
                            let shoppinglist = ShoppingList.save(viewContext: getViewContext(), tag: tag)
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: shoppinglist!, shoppingItem: shoppingItem!)
                        }
                    }
                }
            }
        }
        
        let sapis: [Recipe] = categories.getRecipeByCategory(category: .sapi)!
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        let nextDate: Date  = theCalendar.date(byAdding: dayComponent, to: Date())!
        for sapi: Recipe in sapis {
            let plan = Plan.save(viewContext: getViewContext(), date: nextDate, recipeId: sapi.id!, recipeName: sapi.name!, recipePhoto: sapi.photo!, duration: Int16(sapi.duration!), portion: Int16(sapi.portion!))
            for ingredientSection in sapi.ingredientSections! {
                for ingredient in ingredientSection.ingredients! {
                    for tag in ingredient.tag! {
                        let shoppingItem = ShoppingItem.save(viewContext: getViewContext(), name: ingredient.name!, qty: ingredient.qty!, unit: ingredient.unit!)
                        let existingTag = ShoppingList.fetchDataWithKey(viewContext: getViewContext(), tag: tag)
                        if existingTag != nil {
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: existingTag!, shoppingItem: shoppingItem!)
                        } else {
                            let shoppinglist = ShoppingList.save(viewContext: getViewContext(), tag: tag)
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: shoppinglist!, shoppingItem: shoppingItem!)
                        }
                    }
                }
            }
        }
        
        let plans = Plan.fetchAll(viewContext: getViewContext())
        
        for plan in plans {
            print("plan date: \(plan.plan_date!)")
            print("recipe id: \(plan.recipe_id!)")
            print("recipe name: \(plan.recipe_name!)")
            print("recipe photo: \(plan.recipe_photo!)")
            print("recipe duration: \(plan.recipe_duration)")
            print("recipe portion: \(plan.recipe_portion)")
            print("shopping list:")
            print("\n\n")
        }
        
//        let shoppingList = ShoppingList.fetchAll(viewContext: getViewContext())
//        for s in shoppingList {
//            if let plans: [Plan] = s.plan?.allObjects as! [Plan] {
//                for plan in plans {
//                    print("Recipe Name \(plan.recipe_name)")
//                }
//            }
//
//            if let items: [ShoppingItem] = s.shopping_item!.allObjects as! [ShoppingItem] { //assuming you have name your to-many relationship 'sets'
//                for item in items {
//                    print(item.item_name!)
//                }
//            }
//        }
    }


}

