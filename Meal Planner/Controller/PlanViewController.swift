//
//  PlanViewController.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 14/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var emptyViewContainer: UIView!
    @IBOutlet var btnMulai: UIButton!
    @IBOutlet var tableViewContainer: UIView!
    @IBOutlet var tableView: UITableView!
    
    let cellIdentifier = "CellPlan"
    
    var plans: [Plan] = []
    var plansWithSection: [PlanSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        plans = Plan.fetchQueryAfterDate(viewContext: getViewContext(), date: Date())
        if (plans.count > 0) {
            preparePlanContainer()
        } else {
            prepareEmptyContainer()
        }
    }
    
    func prepareEmptyContainer() {
        btnMulai.layer.cornerRadius = 8
        tableViewContainer.isHidden = true
        emptyViewContainer.isHidden = false
    }
    
    func preparePlanContainer() {
        
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
        
        let planSection = PlanSection(date: prevPlanDate, plans: planDatas)
        plansWithSection.append(planSection)
                
        tableViewContainer.isHidden = false
        emptyViewContainer.isHidden = true
        self.tableView.register(UINib(nibName: "PlanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView?.isHidden = true
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
        return dateFormatterPrint.string(from: plansWithSection[section].date!)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.init(red: CGFloat(120/255), green: CGFloat(120/255), blue: CGFloat(120/255), alpha: CGFloat(1))
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlanTableViewCell
                
        cell.recipeImageView.image = UIImage(named: plansWithSection[indexPath.section].plans[indexPath.row].recipe_photo!)
        cell.recipeNameLabel.text = plansWithSection[indexPath.section].plans[indexPath.row].recipe_name
        cell.recipeDurationLabel.text = "\(plansWithSection[indexPath.section].plans[indexPath.row].recipe_duration) Menit"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlan: Plan = plansWithSection[indexPath.section].plans[indexPath.row]
        print(selectedPlan)
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
