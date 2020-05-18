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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        plans = Plan.fetchAll(viewContext: getViewContext())
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
        tableViewContainer.isHidden = false
        emptyViewContainer.isHidden = true
        self.tableView.register(UINib(nibName: "PlanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        return dateFormatterPrint.string(from: plans[section].plan_date!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlanTableViewCell
        
        print(indexPath)
        
        cell.recipeImageView.image = UIImage(named: plans[indexPath.row].recipe_photo!)
        cell.recipeNameLabel.text = plans[indexPath.row].recipe_name
        cell.recipeDurationLabel.text = "30 menit"
        
        return cell
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
