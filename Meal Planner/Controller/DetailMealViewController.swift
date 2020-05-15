//
//  DetailMealViewController.swift
//  Meal Planner
//
//  Created by Fandrian Rhamadiansyah on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class DetailMealViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var recipeScrollView: UIScrollView!
    
    
    var recipe = categories.getRecipeByCategory(category: .ayam)![0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeScrollView.delegate = self
        let temp = breakdownRecipe(recipe: recipe)
        
        ingredientsLabel.text = temp
        //        ingredientsLabel.text = "safn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanfsafn ojenwakdjnsjanerfanf"
        
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.recipeScrollView.contentOffset.y)
    }
    
    
    func breakdownRecipe(recipe : Recipe) -> String {
        var temp = ""
        // Ingredients section
        for item in recipe.ingredientSections! {
            temp += item.section!
            temp += ":"
            for list in item.ingredients! {
                temp += "\n\(list.name ?? "")"
            }
            temp += "\n\n"
        }
        
        for item in recipe.stepSections! {
            temp += "\(item.section ?? "") : \n\(item.steps!.joined(separator: "\n"))"
            temp += "\n\n"
        }
        
        if let tips = recipe.tips {
            temp += "Tips : \n"
            temp += "\(tips.joined(separator: "\n"))\n"
        }
        return temp
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
