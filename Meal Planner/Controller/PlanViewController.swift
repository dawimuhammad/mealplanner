//
//  PlanViewController.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 14/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyDetailMealDelegate {

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
        self.title = "Rencana Masak"
        prepareNavigationButton()
        plans = Plan.fetchQueryAfterDate(viewContext: getViewContext(), date: Date())
        if (plans.count > 0) {
            preparePlanContainer()
        } else {
            prepareEmptyContainer()
        }        
    }
    
    func prepareNavigationButton() {
        let archiveButton   = UIBarButtonItem(image: #imageLiteral(resourceName: "ArchiveButton"),  style: .plain, target: self, action: #selector(didTapArchive))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "AddPlan"),  style: .plain, target: self, action: #selector(didTapAdd))
        self.navigationItem.rightBarButtonItems = [addButton, archiveButton]
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#F19436")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func prepareEmptyContainer() {
        btnMulai.layer.cornerRadius = 8
        tableViewContainer.isHidden = true
        emptyViewContainer.isHidden = false
    }
    
    func preparePlanContainer() {
        prepareSection()
        tableViewContainer.isHidden = false
        emptyViewContainer.isHidden = true
        self.tableView.register(UINib(nibName: "PlanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView?.isHidden = true
    }
    
    func prepareSection() {
        plansWithSection = []
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
                // added by Fandrian (to set print date to current timezone)
                curDateFormat.timeZone = TimeZone.current
                prevDateFormat.timeZone = TimeZone.current

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
        // added by Fandrian (to set print date to current timezone)
        dateFormatterPrint.timeZone = TimeZone.current
        dateFormatterPrint.locale = Locale.init(identifier: "id_ID")
        return dateFormatterPrint.string(from: plansWithSection[section].date!)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor(hex: "#F19436")
        header.textLabel?.textColor = UIColor.init(red: CGFloat(249)/CGFloat(249), green: CGFloat(249)/CGFloat(249), blue: CGFloat(249)/CGFloat(249), alpha: CGFloat(0.94))
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
        performSegue(withIdentifier: "plan2detail", sender: selectedPlan)
    }
    
    @IBAction func onPressMulai(_ sender: Any) {
        navigateToCategory()
    }
    
    @objc func didTapAdd(sender: AnyObject){
        navigateToCategory()
    }

    @objc func didTapArchive(sender: AnyObject){
        performSegue(withIdentifier: "plan2archive", sender: self)
    }
    
    func navigateToCategory() {
        performSegue(withIdentifier: "plan2category", sender: self)
    }
    
    func updatePlan(plan: Plan) {
        plans = Plan.fetchQueryAfterDate(viewContext: getViewContext(), date: Date())
        print(plans.count)
        if (plans.count == 0) {
            prepareEmptyContainer()
        } else {
            preparePlanContainer()
            self.tableView.reloadData()
        }
    }
    
    func deletePlan(plan: Plan) {
        Plan.deletePlan(viewContext: getViewContext(), plan: plan)
        plans = Plan.fetchQueryAfterDate(viewContext: getViewContext(), date: Date())
        print(plans.count)
        if (plans.count > 0) {
            prepareSection()
            self.tableView.reloadData()
        } else {
            prepareEmptyContainer()
        }
    }
    
//    func updateNewPlan(newPlan: Plan) {
//        let curDateFormat = DateFormatter()
//        let prevDateFormat = DateFormatter()
//        curDateFormat.dateFormat = "MMM dd,yyyy"
//        prevDateFormat.dateFormat = "MMM dd,yyyy"
//        // added by Fandrian (to set print date to current timezone)
//        curDateFormat.timeZone = TimeZone.current
//        prevDateFormat.timeZone = TimeZone.current
//
//        if let row = plansWithSection.firstIndex(where: {prevDateFormat.string(from: $0.date!) == curDateFormat.string(from: newPlan.plan_date!)}) {
//            plansWithSection[row].plans.append(newPlan)
//        } else {
//            plansWithSection.append(PlanSection(date: newPlan.plan_date, plans: [newPlan]))
//        }
//
//        plansWithSection = plansWithSection.sorted(by: { curDateFormat.string(from: $0.date!) < curDateFormat.string(from: $1.date!) })
//        tableView.reloadData()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "plan2category"){
            let destinationVC = segue.destination as! CategoryViewController
            destinationVC.delegate =  self
        }
        
        if let identifier = segue.identifier {
            if identifier == "plan2detail" {
                if let destinationVC = segue.destination as? DetailMealViewController{
                    let selectedPlan: Plan = sender as! Plan
                    let selectedRecipe: Recipe? = categories.getRecipeById(id: selectedPlan.recipe_id!)
                    destinationVC.recipe = selectedRecipe!
                    destinationVC.fromPlan = true
                    destinationVC.selectedPlan = selectedPlan
                    destinationVC.delegate = self
                }
            }
        }
    }
    
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
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
