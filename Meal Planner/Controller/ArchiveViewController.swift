//
//  ArchiveViewController.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 19/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let cellIdentifier = "CellPlan"
    
    var plans: [Plan] = []
    var plansWithSection: [PlanSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true
        plans = Plan.fetchQueryBeforeDate(viewContext: getViewContext(), date: Date())
        preparePlanSection()
        
        self.tableView.register(UINib(nibName: "PlanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func preparePlanSection() {
        var prevPlanDate: Date? = nil
        var planDatas: [Plan] = []
        for plan in plans {
            let curPlanDate = plan.plan_date
            
            if (prevPlanDate == nil) {
                prevPlanDate = curPlanDate
            } else {
                let curDateFormat = DateFormatter()
                let prevDateFormat = DateFormatter()
                curDateFormat.dateFormat = "MMM dd,yyyy"
                prevDateFormat.dateFormat = "MMM dd,yyyy"
                
                if (curDateFormat.string(from: curPlanDate!) != prevDateFormat.string(from: prevPlanDate!) ) {
                    let planSection = PlanSection(date: prevPlanDate, plans: planDatas)
                    plansWithSection.append(planSection)
                    prevPlanDate = curPlanDate
                    planDatas = []
                }
            }
            
            planDatas.append(plan)
        }
        
        if (prevPlanDate != nil) {
            let planSection = PlanSection(date: prevPlanDate, plans: planDatas)
            plansWithSection.append(planSection)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        plansWithSection.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(29)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plansWithSection[section].plans.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "cccc, dd MMM yyyy"
        dateFormatterPrint.locale = Locale.init(identifier: "id_ID")
        return plansWithSection.count > 0 ? dateFormatterPrint.string(from: plansWithSection[section].date!) : nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor(hex: "#E0E0E0")
        header.textLabel?.textColor = UIColor(hex: "#787878")
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlanTableViewCell
        
        cell.recipeImageView.image = UIImage(named: plansWithSection[indexPath.section].plans[indexPath.row].recipe_photo!)
        cell.recipeImageView.layer.cornerRadius = 10
        cell.recipeNameLabel.text = plansWithSection[indexPath.section].plans[indexPath.row].recipe_name
        cell.recipeDurationLabel.text = "\(plansWithSection[indexPath.section].plans[indexPath.row].recipe_duration) Menit"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlan: Plan = plansWithSection[indexPath.section].plans[indexPath.row]
        let selectedRecipe: Recipe? = categories.getRecipeById(id: selectedPlan.recipe_id!)
        performSegue(withIdentifier: "archive2detail", sender: selectedRecipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let identifier = segue.identifier {
            if identifier == "archive2detail" {
                if let destinationVC = segue.destination as? DetailMealViewController{
                    destinationVC.recipe = sender as! Recipe
                    destinationVC.fromArchive = true
                }
            }
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
