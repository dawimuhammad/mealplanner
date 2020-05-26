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
    
    var shoppingLists: [ShoppingList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Daftar Belanja"
        fetchShoppingList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        shoppingLists.count
    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        fetchShoppingList()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists[section].shopping_item?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let itemsInList = shoppingLists[indexPath.section].shopping_item?.allObjects as! [ShoppingItem]
        
        cell.textLabel?.text = itemsInList[indexPath.row].item_name
        cell.detailTextLabel?.text = "\(itemsInList[indexPath.row].item_qty) \(String(describing: itemsInList[indexPath.row].item_unit))"
        cell.imageView?.image = UIImage(named: "checkbox-unmark")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shoppingLists[section].shopping_tag?.capitalizingEachWords().removeDashSymbols()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // code here
    }
    
    func fetchShoppingList() {
        shoppingLists = ShoppingList.fetchAll(viewContext: getViewContext())
    }
}
