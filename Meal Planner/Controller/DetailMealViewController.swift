//
//  DetailMealViewController.swift
//  Meal Planner
//
//  Created by Fandrian Rhamadiansyah on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit
import QuartzCore

protocol MyDetailMealDelegate {
    func updatePlan(plan: Plan)
}

class DetailMealViewController: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var tambahRencanaButton: UIButton!
    @IBOutlet weak var tambahRencanaView: UIView!
    
    
    
    @IBOutlet var popoverDatePicker: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: MyDetailMealDelegate?
    
    
    var recipe = categories.getRecipeByCategory(category: .ayam)![0]
    
    var date = Date()
    
    var fromPlan: Bool = false
    var fromArchive: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(fromPlan)
        if fromArchive {
            tambahRencanaView.isHidden = true
            tambahRencanaButton.isHidden = true
            print("hide") }
        
        if (fromPlan) {
            tambahRencanaButton.setTitle("Hapus Rencana", for: .normal)
            tambahRencanaButton.backgroundColor = .systemBackground
            tambahRencanaButton.setTitleColor(UIColor.init(hex: "#F19437"), for: .normal)
            tambahRencanaButton.layer.borderWidth = 2.0
            tambahRencanaButton.layer.borderColor = UIColor.init(hex: "#F19437")?.cgColor
            
        }
    }
    
    @IBAction func tambahRencanaButtonPressed(_ sender: UIButton) {
        print("fromplan = \(fromPlan), fromarchive = \(fromArchive) ")
        if fromPlan {
            print("delete")
            createAlert(titles: recipe.name!, message: "Apakah kamu yakin mau menghapus \(recipe.name!) dalam rencana masakmu?", forDelete: true) { (UIAlertAction) in self.deleteRecipeFromPlan() }
        } else {
            self.view.addSubview(popoverDatePicker)
            popoverDatePicker.center = self.view.center
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
        dateFormatter.timeZone =  TimeZone.current
        
        print(datePicker.date)
        
        
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        // save plan
        
        date = datePicker.date
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone =  TimeZone.current
        
        let newPlan: Plan = Plan.savePlan(viewContext: getViewContext(), date: date, recipe: recipe)
        self.delegate?.updatePlan(plan: newPlan)
        self.popoverDatePicker.removeFromSuperview()
        createAlert(titles: recipe.name!, message: "Sudah dimasukkan ke rencana masak kamu pada \(dateFormatter.string(from: date))", forDelete: false) { (UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToPlan", sender: self)
        }
        
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.popoverDatePicker.removeFromSuperview()
    }
    
    func createAlert(titles:String, message:String, forDelete : Bool, handlerRESET: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: titles, message: message, preferredStyle: .alert)
        if (forDelete) {
            alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler:
                //            {action in self.performSegue(withIdentifier: "unwindToPlan", sender: self)}
                {action in self.deleteRecipeFromPlan()}
            ))
            
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.performSegue(withIdentifier: "unwindToPlan", sender: self)}))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteRecipeFromPlan() {
        // add delete from coredata function
        print("DELETE YES")
        // perform unwind segue
        performSegue(withIdentifier: "unwindToPlan", sender: self)
        
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

