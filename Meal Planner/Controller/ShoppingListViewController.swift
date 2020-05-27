//
//  ShoppingListViewController.swift
//  Meal Planner
//
//  Created by Haddawi on 18/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import UIKit

struct LocalShoppingList {
    var shopping_tag: String
    var is_complete: Bool = false
    var shopping_items: [ShoppingItem]
}

class ShoppingListViewController: UITableViewController {
    
    var filterShopingList: [LocalShoppingList] = []
    
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
        return filterShopingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let itemsInList = filterShopingList[indexPath.row].shopping_items
        cell.textLabel?.text = filterShopingList[indexPath.row].shopping_tag.capitalizingEachWords().removeDashSymbols()
        cell.detailTextLabel?.text = combineItemUnit(itemList: itemsInList)
        cell.imageView?.image = filterShopingList[indexPath.row].is_complete == true ? UIImage(named: "checkbox-marked") : UIImage(named: "checkbox-unmark")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let selectedRow = filterShopingList[indexPath.row]
        let isComplete = selectedRow.is_complete == true ? false : true
        ShoppingList.updateComplete(viewContext: getViewContext(), shoppingList: filterShopingList[indexPath.row], isComplete: isComplete)
        filterShopingList[indexPath.row].is_complete = isComplete
        self.tableView.reloadData()
    }
    
    func fetchShoppingList() {
        filterShopingList = []
        let tempShoppingList = ShoppingList.fetchAll(viewContext: getViewContext())
        for shoppingList in tempShoppingList {
            let shopingItems: [ShoppingItem] = shoppingList.shopping_item?.allObjects as! [ShoppingItem]
            for item in shopingItems {
                print(item.item_name, item.plan?.recipe_name)
            }
            let filterShopingItem: [ShoppingItem] = shopingItems.filter({
                ($0.plan as! Plan).plan_date! >= Calendar.current.startOfDay(for: Date())
            })
            if filterShopingItem.count > 0 {
                filterShopingList.append(LocalShoppingList(shopping_tag: shoppingList.shopping_tag!, is_complete: shoppingList.is_complete, shopping_items: filterShopingItem))
            }
        }
    }
    
    func combineItemUnit(itemList: [ShoppingItem]) -> String {
        var arrQtyUnit: [QtyUnit] = []
        var result: String = ""
        
        for item in itemList {
            let newQtyUnit: QtyUnit = QtyUnit(qty: item.item_qty, unit: item.item_unit)
            let curArrQtyUnitIndex = arrQtyUnit.firstIndex(where: {$0.unit == newQtyUnit.unit})
            if let index = curArrQtyUnitIndex {
                arrQtyUnit[index].qty += newQtyUnit.qty ?? 0.0
            } else {
                arrQtyUnit.append(newQtyUnit)
            }
        }
        
        for (index, item) in arrQtyUnit.enumerated() {
            if (item.unit == "secukupnya") {
                result = "\(result) \(item.unit!)"
            } else {
                result = "\(result) \(item.qty) \(item.unit!)"
            }
            
            if (index < arrQtyUnit.count - 1) {
                result = "\(result), "
            }
        }
                
        return result
    }
    
}
