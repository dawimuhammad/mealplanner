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
        
        // sample usage of categories usage
        let ayams: [Recipe] = categories.getRecipeByCategory(category: .ayam)!
        for ayam: Recipe in ayams {
            let plan = Plan.save(viewContext: getViewContext(), date: Date(), recipeId: ayam.id!, recipeName: ayam.name!, recipePhoto: ayam.photo!)
            for ingredientSection in ayam.ingredientSections! {
                for ingredient in ingredientSection.ingredients! {
                    for tag in ingredient.tag! {
                        let shoppingItem = ShoppingItem.save(viewContext: getViewContext(), name: ingredient.name!, qty: ingredient.qty!, unit: ingredient.unit!)
                        let existingTag = ShoppingList.fetchDataWithKey(viewContext: getViewContext(), tag: tag)
                        if existingTag != nil {
                            ShoppingList.addShoppingItem(viewContext: getViewContext(), instance: existingTag!, shoppingItem: shoppingItem!)
                        } else {
                            let shoppinglist = ShoppingList.save(viewContext: getViewContext(), tag: tag)
                            ShoppingList.addPlan(viewContext: getViewContext(), instance: shoppinglist!, plan: plan!)
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
            print("shopping list:")
            if let shoppingList: [ShoppingList] = plan.shopping_list?.allObjects as! [ShoppingList] {
                for shopping in shoppingList {
                    print(shopping.shopping_tag!)
                }
            }
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

