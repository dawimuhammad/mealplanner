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
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        fetchShoppingList()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let itemsInList = shoppingLists[indexPath.row].shopping_item?.allObjects as! [ShoppingItem]
        let itemsToBuy = itemsInList.removeDuplicates()
        
        cell.textLabel?.text = shoppingLists[indexPath.row].shopping_tag?.capitalizingEachWords().removeDashSymbols()
        cell.detailTextLabel?.text = itemsToBuy
        cell.imageView?.image = shoppingLists[indexPath.row].is_complete == true ? UIImage(named: "checkbox-marked") : UIImage(named: "checkbox-unmark")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let selectedRow = shoppingLists[indexPath.row]
        let isComplete = selectedRow.is_complete == true ? false : true
        ShoppingList.updateComplete(viewContext: getViewContext(), shoppingList: shoppingLists[indexPath.row], isComplete: isComplete)

        self.tableView.reloadData()
    }
    
    func fetchShoppingList() {
        shoppingLists = ShoppingList.fetchAll(viewContext: getViewContext())
    }
}
