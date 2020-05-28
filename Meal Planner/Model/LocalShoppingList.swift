//
//  LocalShoppingList.swift
//  Meal Planner
//
//  Created by Haddawi on 27/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation

struct LocalShoppingList {
    var shopping_tag: String
    var is_complete: Bool = false
    var shopping_items: [ShoppingItem]
}
