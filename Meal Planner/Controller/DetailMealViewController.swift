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
    func deletePlan(plan: Plan)
}

class DetailMealViewController: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var tambahRencanaButton: UIButton!
    @IBOutlet weak var tambahRencanaView: UIView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    //all view?
    @IBOutlet weak var scrollContainerView: UIView!
    
    
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
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true
        
        recipeTitleLabel.text = recipe.name!
        
        durationLabel.text = ": \(recipe.duration!) menit"
        portionLabel.text = ": \(recipe.portion!) orang"
        mealImage.image = UIImage(named: recipe.photo!)
        sourceLabel.text = "Diambil Dari : \(recipe.source?.regex(pattern: "(?<=//)([a-z0-9]*.[a-z0-9]*)")[0] ?? "cookpad.com")"
        
        ingredientsLabel.text = breakdownIngredients(recipe: recipe)
        stepsLabel.text = breakdownSteps(recipe: recipe)
        
        var maxDayComponent = DateComponents()
        var minDayComponent = DateComponents()
        let theCalendar     = Calendar.current
        
        maxDayComponent.day = 14
        minDayComponent.day = -7
        let maxDate: Date = theCalendar.date(byAdding: maxDayComponent, to: Date())!
        let minDate: Date = theCalendar.date(byAdding: minDayComponent, to: Date())!

        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate //maximum pick one month from today
        datePicker.locale = Locale.init(identifier: "id_ID")
        
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
            tambahRencanaButton.backgroundColor = .systemBackground
            tambahRencanaButton.layer.borderWidth = 1
            tambahRencanaButton.layer.borderColor = UIColor(hex: "#F19437")?.cgColor
        }
    }
    
    @IBAction func tambahRencanaButtonPressed(_ sender: UIButton) {
        print("fromplan = \(fromPlan), fromarchive = \(fromArchive) ")
        if fromPlan {
            createAlert(titles: recipe.name!, message: "Apakah kamu yakin mau menghapus \(recipe.name!) dalam rencana masakmu?", forDelete: true) { (UIAlertAction) in self.deleteRecipeFromPlan() }
        } else {
            dimSuperview(true)
            self.view.addSubview(popoverDatePicker)
            popoverDatePicker.center = self.view.center
        }
        
    }
    
    
    
    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone =  TimeZone.current
        dateFormatter.locale = Locale.init(identifier: "id_ID")
        
        print(datePicker.date)
        
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        // save plan
        
        date = datePicker.date
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone =  TimeZone.current
        dateFormatter.locale = Locale.init(identifier: "id_ID")
        
        let newPlan: Plan = Plan.savePlan(viewContext: getViewContext(), date: date, recipe: recipe)
        self.delegate?.updatePlan(plan: newPlan)
        // dim superview
        dimSuperview(false)
        //remove popover
        self.popoverDatePicker.removeFromSuperview()
        createAlert(titles: recipe.name!, message: "Sudah dimasukkan ke rencana masak kamu pada \(dateFormatter.string(from: date))", forDelete: false) { (UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToPlan", sender: self)
        }
        
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.popoverDatePicker.removeFromSuperview()
        dimSuperview(false)
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
        self.delegate?.deletePlan(plan: selectedPlan!)
        // perform unwind segue
        performSegue(withIdentifier: "unwindToPlan", sender: self)
    }
    
    
    func breakdownIngredients(recipe : Recipe) -> String {
        var temp = ""
        // Ingredients section
        if recipe.ingredientSections!.count == 1 {
            for item in recipe.ingredientSections! {
                for list in item.ingredients! {
                    temp += "\(list.name ?? "")\n"
                }
                temp += "\n"
            }
        } else {
            for item in recipe.ingredientSections! {
                temp += item.section!
                temp += ":"
                for list in item.ingredients! {
                    temp += "\n\(list.name ?? "")"
                }
                temp += "\n"
            }
        }
        return temp
    }
    
    func breakdownSteps(recipe : Recipe) -> String {
        var temp = ""
        
        if recipe.stepSections?.count == 1 {
            for item in recipe.stepSections! {
                temp += "\(item.steps!.joined(separator: "\n"))"
                temp += "\n"
            }
        } else {
            for item in recipe.stepSections! {
                temp += "\(item.section ?? "") : \n\(item.steps!.joined(separator: "\n"))"
                temp += "\n"
            }
        }
        
        
        if recipe.tips?.count != 0 {
            temp += "Tips : \n"
            temp += "\(recipe.tips?.joined(separator: "\n") ?? "")\n"
        }
        return temp
    }
    
    func dimSuperview(_ value: Bool){
        if (value) {
            self.scrollContainerView.alpha = 0.1
            self.mealImage.alpha = 0.1
            self.view.backgroundColor = UIColor.lightGray
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tambahRencanaView.alpha = 0.1
        } else {
            self.scrollContainerView.alpha = 1.0
            self.mealImage.alpha = 1.0
            self.view.backgroundColor = .systemBackground
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.tambahRencanaView.alpha = 1.0
        }
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

