//
//  ShoppingListViewController.swift
//  Meal Planner
//
//  Created by Haddawi on 18/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListViewController: UITableViewController {
    
    struct Ingredient {
        var name: String
        var quantity: String
    }
    
    let ingredients = [
        Ingredient(name: "Ayam", quantity: "1 ekor utuh"),
        Ingredient(name: "Sapi", quantity: "1/2 kg"),
        Ingredient(name: "Ikan Bawal", quantity: "3 kg"),
        Ingredient(name: "Laos Geprek", quantity: "3 cm"),
        Ingredient(name: "Gula", quantity: "250 gram"),
        Ingredient(name: "Daun Salam", quantity: "2 lembar"),
        Ingredient(name: "Ceker Ayam", quantity: "1/2 kg")
    ]
    var currentIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Daftar Belanja"
    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let ingredientItem = ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredientItem.name
        cell.detailTextLabel?.text = ingredientItem.quantity
        cell.imageView?.image = UIImage(named: "checkbox-marked")
        
        return cell
    }
    
    func filterCurrentDataSource(searchKey: String) {
    }
}
