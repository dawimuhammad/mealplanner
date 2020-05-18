//
//  PlanViewController.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 14/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController {

    @IBOutlet var emptyViewContainer: UIView!
    @IBOutlet var btnMulai: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plan: [Any] = []
        // Do any additional setup after loading the view.
        if (plan.count > 0) {
            preparePlanContainer()
        } else {
            prepareEmptyContainer()
        }
    }
    
    func prepareEmptyContainer() {
        btnMulai.layer.cornerRadius = 8
    }
    
    func preparePlanContainer() {
        
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
