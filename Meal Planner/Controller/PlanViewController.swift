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
    
    var plans: [Plan] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable", for: indexPath)
        
        cell.textLabel?.text = plans[indexPath.row].recipe_name
        cell.detailTextLabel?.text = plans[indexPath.row].recipe_name
        cell.imageView?.image = UIImage(named: plans[indexPath.row].recipe_photo!)

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
