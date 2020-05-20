//
//  Category.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 14/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation

class Categories {
    private var arrCategory: [CategoryEnum: [Recipe]] = [:]
    private var allRecipes: [Recipe] = []
    
    init() {
        let ayamRecipes = getRecipesFromJSON(fileName: "ayam")
        let sapiRecipes = getRecipesFromJSON(fileName: "sapi")
        let ikanRecipes = getRecipesFromJSON(fileName: "ikan")
        let babiRecipes = getRecipesFromJSON(fileName: "babi")
        let sayurRecipes = getRecipesFromJSON(fileName: "sayur")
        let lainnyaRecipes = getRecipesFromJSON(fileName: "other")
        allRecipes.append(contentsOf: ayamRecipes)
        allRecipes.append(contentsOf: sapiRecipes)
        allRecipes.append(contentsOf: ikanRecipes)
        allRecipes.append(contentsOf: babiRecipes)
        allRecipes.append(contentsOf: sayurRecipes)
        allRecipes.append(contentsOf: lainnyaRecipes)
        arrCategory[.ayam] = ayamRecipes
        arrCategory[.sapi] = sapiRecipes
        arrCategory[.ikan] = ikanRecipes
        arrCategory[.babi] = babiRecipes
        arrCategory[.sayur] = sayurRecipes
        arrCategory[.lainnya] = lainnyaRecipes
    }
    
    private func getRecipesFromJSON(fileName: String) -> [Recipe]{
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [Any]
            var recipes: [Recipe] = []
            for recipeDict in json {
                if let recipe = recipeDict as? [String: Any] {
                    
                    // section to parse ingredient_sections
                    let recipeIngredientSections: [[String: Any]] = recipe["ingredient_section"] as! [[String: Any]]
                    var ingredientSections: [IngredientSection] = []
                    for recipeIngredientSection: [String: Any] in recipeIngredientSections {
                        let recipeIngredients: [[String: Any]] = recipeIngredientSection["ingredients"] as! [[String: Any]]
                        var ingredients: [Ingredient] = []
                        
                        for recipeIngredient: [String: Any] in recipeIngredients {
                            let ingredient: Ingredient = Ingredient(
                                tag: recipeIngredient["tag"] as? [String],
                                name: recipeIngredient["name"] as? String,
                                unit: recipeIngredient["unit"] as? String,
                                qty: recipeIngredient["qty"] as? Float)
                            ingredients.append(ingredient)
                        }
                        
                        let ingredientSection: IngredientSection = IngredientSection(
                            section: recipeIngredientSection["section"] as? String,
                            ingredients: ingredients
                        )
                        
                        ingredientSections.append(ingredientSection)
                    }
                    
                    // section to parse steps
                    let recipeStepSections: [[String: Any]] = recipe["steps"] as! [[String: Any]]
                    var stepSections: [StepSection] = []
                    for recipeStepSection: [String: Any] in recipeStepSections {
                        let stepSection: StepSection = StepSection(
                            section: recipeStepSection["section"] as? String,
                            steps: recipeStepSection["steps"] as? [String]
                        )
                        
                        stepSections.append(stepSection)
                    }
                    
                    let classRecipe = Recipe(
                        id: recipe["id"] as! String,
                        name:recipe["name"] as! String,
                        category: getRecipeCategory(stringCategory: recipe["category"] as! String)!,
                        photo: recipe["photo"] as! String,
                        duration: recipe["duration"] as! Int,
                        portion: recipe["portion"] as! Int,
                        ingredientSections: ingredientSections,
                        stepSections: stepSections,
                        tips: recipe["tips"] as? [String],
                        source: recipe["source"] as? String
                    )
                    recipes.append(classRecipe)
                }
            }
            
            return recipes
        }
        catch {
            return []
        }
    }
    
    private func getRecipeCategory(stringCategory: String) -> CategoryEnum? {
        switch stringCategory{
        case "ayam":
            return .ayam
        case "babi":
            return .babi
        case "ikan":
            return .ikan
        case "sapi":
            return .sapi
        case "sayur":
            return .sayur
        case "lainnya":
            return .lainnya
        default:
            return nil
        }
    }
    
    public func getAllCategory() -> [CategoryEnum: [Recipe]] {
        return arrCategory
    }
    
    public func getRecipeByCategory(category: CategoryEnum) -> [Recipe]? {
        return arrCategory[category]
    }
    
    public func getAllRecipes() -> [Recipe] {
        return allRecipes
    }
    
//    public func getRecipeById(id: String) -> Recipe {
//        
//    }
}
