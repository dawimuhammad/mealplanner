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
        if isFiltering() { return filteredShoppingList.count }
        
        return filterShopingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentShoppingList: LocalShoppingList
        
        if isFiltering() {
            currentShoppingList = filteredShoppingList[indexPath.row]
        } else {
            currentShoppingList = filterShopingList[indexPath.row]
        }
        
        let itemsInList = currentShoppingList.shopping_items
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
            }
            
            return cell
        }()
        
        cell.detailTextLabel?.textColor = UIColor(hex: "#979797")
        
        cell.textLabel?.text = currentShoppingList.shopping_tag.capitalizingEachWords().removeDashSymbols()
        cell.detailTextLabel?.text = combineItemUnit(itemList: itemsInList)
        cell.imageView?.image = currentShoppingList.is_complete == true ? UIImage(named: "checkbox-marked") : UIImage(named: "checkbox-unmark")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var currentShoppingList: LocalShoppingList
        
        if isFiltering() {
            currentShoppingList = filteredShoppingList[indexPath.row]
        } else {
            currentShoppingList = filterShopingList[indexPath.row]
        }
        
        let isComplete = currentShoppingList.is_complete == true ? false : true
        ShoppingList.updateComplete(viewContext: getViewContext(), shoppingList: currentShoppingList, isComplete: isComplete)
        currentShoppingList.is_complete = isComplete
        fetchShoppingList()
        filterContentForSearchText(searchText: searchController.searchBar.text!)
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

extension ShopListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
