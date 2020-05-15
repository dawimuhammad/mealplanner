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
            print(ayam.name!)
//            var shoppintItems: [ShoppingItem] = []
            for ingredientSection in ayam.ingredientSections! {
                for ingredient in ingredientSection.ingredients! {
                    for tag in ingredient.tag! {
                        print(tag)
//                        let _ = ShoppingList.save(viewContext: getViewContext(), tag: tag)
                    }
                }
            }
        }
        
        let shoppingList = ShoppingList.fetchAll(viewContext: getViewContext())
        for s in shoppingList {
            print(s.shopping_tag)
//            if let items = s.shopping_item { //assuming you have name your to-many relationship 'sets'
//                print(items)
//            }
        }
    }


}

