//
//  Recipe.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 14/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation

class Recipe {
    var id: String?
    var name: String?
    var category: CategoryEnum?
    var photo: String?
    var duration: Int?
    var portion: Int?
    var ingredientSections: [IngredientSection]?
    var stepSections: [StepSection]?
    var tips: [String]?
    var source: String?
    
    init(id: String, name: String, category: CategoryEnum, photo: String, duration: Int, portion: Int, ingredientSections: [IngredientSection], stepSections: [StepSection], tips: [String]?, source: String?) {
        
        self.id = id
        self.name = name
        self.category = category
        self.photo = photo
        self.duration = duration
        self.portion = portion
        self.ingredientSections = ingredientSections
        self.stepSections = stepSections
        self.tips = tips
        self.source = source
    }
}
