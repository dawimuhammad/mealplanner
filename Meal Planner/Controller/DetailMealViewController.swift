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
    func deletePlan(plan: Plan)
}

class DetailMealViewController: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var tambahRencanaButton: UIButton!

    
    @IBOutlet var popoverDatePicker: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: MyDetailMealDelegate?
    
    
    var recipe = categories.getRecipeByCategory(category: .ayam)![0]
    
    var date = Date()
    
    var fromPlan: Bool = false
    var fromArchive: Bool = false
    var selectedPlan: Plan?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recipeScrollView.delegate = self
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true
        
        let temp = breakdownRecipe(recipe: recipe)
        
        recipeTitleLabel.text = recipe.name!
        
        durationLabel.text = ": \(recipe.duration!) menit"
        portionLabel.text = ": \(recipe.portion!) orang"
        mealImage.image = UIImage(named: recipe.photo!)
        
        ingredientsLabel.text = temp
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date(timeIntervalSinceNow: 60*60*24*30) //maximum pick one month from today
        
        // Do any additional setup after loading the view.
        
        if (fromArchive) {
            tambahRencanaButton.isEnabled = false
            tambahRencanaButton.setTitle("Hapus Rencana", for: .disabled)
            tambahRencanaButton.setTitleColor(UIColor(hex: "#787878"), for: .disabled)
            tambahRencanaButton.backgroundColor = UIColor(hex: "#E0E0E0")
        }
        
        if (fromPlan) {
            tambahRencanaButton.setTitle("Hapus Rencana", for: .normal)
            tambahRencanaButton.setTitleColor(UIColor(hex: "#F19437"), for: .normal)
            tambahRencanaButton.backgroundColor = .white
            tambahRencanaButton.layer.borderWidth = 1
            tambahRencanaButton.layer.borderColor = UIColor(hex: "#F19437")?.cgColor
        }
    }
    
    @IBAction func displayPopover(_ sender: UIButton) {
        if (fromPlan) {
            showDeleteAlert()
        } else {
            self.view.addSubview(popoverDatePicker)
            popoverDatePicker.center = self.view.center
            // self.view.superview?.alpha = 0.1
            print("muncul??")
                    
        }
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

        if recipe.tips?.count != 0 {
            temp += "Tips : \n"
            temp += "\(recipe.tips?.joined(separator: "\n") ?? "")\n"
        }

        return temp
    }
    
    
    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        print(datePicker.date)
//        print(datePicker.timeZone!)
        datePicker.timeZone = TimeZone(abbreviation: "WIB")
//        print(datePicker)
        print(datePicker.date)
//        let strDate = dateFormatter.string(from: date)
        
        
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        // save plan
        date = datePicker.date
        print(date)
        let newPlan: Plan = Plan.savePlan(viewContext: getViewContext(), date: date, recipe: recipe)
        self.delegate?.updatePlan(plan: newPlan)
//        self.view.alpha = 1.0
        self.popoverDatePicker.removeFromSuperview()
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
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
    
     func showDeleteAlert() {
           //Creating UIAlertController and
           //Setting title and message for the alert dialog
           let alertController = UIAlertController(title: "Hapus Plan", message: "Apakah kamu yakin ingin menghapus ini dari rencana?", preferredStyle: .alert)
           
           //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Ya", style: .destructive) { (_) in
               
               //getting the input values from user
            if let plan = self.selectedPlan {
                self.delegate?.deletePlan(plan: plan)
                self.navigationController?.popViewController(animated: true)
            }
           }
           
           //the cancel action doing nothing
           let cancelAction = UIAlertAction(title: "Tidak", style: .cancel) { (_) in }
           
           
           //adding the action to dialogbox
           alertController.addAction(confirmAction)
           alertController.addAction(cancelAction)
           
           //finally presenting the dialog box
           self.present(alertController, animated: true, completion: nil)
       }
}

