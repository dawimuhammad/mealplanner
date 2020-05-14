//
//  ViewController.swift
//  Meal Planner
//
//  Created by Haddawi on 07/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sample usage of categories usage
        let ayams: [Recipe] = categories.getRecipeByCategory(category: .ayam)!
        for ayam: Recipe in ayams {
            print(ayam.name!)
        }
        // Do any additional setup after loading the view.        
    }


}

