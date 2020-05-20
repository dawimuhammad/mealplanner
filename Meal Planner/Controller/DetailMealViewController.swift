//
//  DetailMealViewController.swift
//  Meal Planner
//
//  Created by Fandrian Rhamadiansyah on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

protocol MyDetailMealDelegate {
    func updatePlan(plan: Plan)
}

class DetailMealViewController: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    
//    @IBOutlet weak var recipeScrollView: UIScrollView!
    
    @IBOutlet var popoverDatePicker: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: MyDetailMealDelegate?
    
    
    var recipe = categories.getRecipeByCategory(category: .ayam)![0]
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recipeScrollView.delegate = self
        let temp = breakdownRecipe(recipe: recipe)
        
        recipeTitleLabel.text = recipe.name!
        
        durationLabel.text = ": \(recipe.duration!) menit"
        portionLabel.text = ": \(recipe.portion!) orang"
        mealImage.image = UIImage(named: recipe.photo!)
        
        ingredientsLabel.text = temp
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date(timeIntervalSinceNow: 60*60*24*30) //maximum pick one month from today
        
        print(self.delegate)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func displayPopover(_ sender: UIButton) {
        print("muncul?")
//        self.view.alpha = 0.2
//        self.view.alpha = 0.2
        self.view.addSubview(popoverDatePicker)
//        self.popoverDatePicker.alpha = 0.5
        popoverDatePicker.center = self.view.center
        popoverDatePicker.alpha = 0.5
        print("muncul??")
        
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
    
    
    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        date = datePicker.date
        print(datePicker.timeZone)
        print(date)
//        let strDate = dateFormatter.string(from: date)
        
        
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        // save plan
        print(date)
        let newPlan: Plan = Plan.savePlan(viewContext: getViewContext(), date: date, recipe: recipe)
        self.delegate?.updatePlan(plan: newPlan)
        self.view.alpha = 1.0
        self.popoverDatePicker.removeFromSuperview()
        
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

