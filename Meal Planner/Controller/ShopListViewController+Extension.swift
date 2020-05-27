//
//  ShopListViewController+Extension.swift
//  Meal Planner
//
//  Created by Haddawi on 27/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import UIKit

extension ShopListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterShopingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemsInList = filterShopingList[indexPath.row].shopping_items
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
            }
            
            return cell
        }()
        
        cell.detailTextLabel?.textColor = UIColor(hex: "#979797")
        
        cell.textLabel?.text = filterShopingList[indexPath.row].shopping_tag.capitalizingEachWords().removeDashSymbols()
        cell.detailTextLabel?.text = combineItemUnit(itemList: itemsInList)
        cell.imageView?.image = filterShopingList[indexPath.row].is_complete == true ? UIImage(named: "checkbox-marked") : UIImage(named: "checkbox-unmark")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selectedRow = filterShopingList[indexPath.row]
        let isComplete = selectedRow.is_complete == true ? false : true
        ShoppingList.updateComplete(viewContext: getViewContext(), shoppingList: filterShopingList[indexPath.row], isComplete: isComplete)
        filterShopingList[indexPath.row].is_complete = isComplete
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ShopListViewController {
    func setupElements() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
