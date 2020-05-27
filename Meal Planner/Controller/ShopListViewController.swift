//
//  ShopListViewController.swift
//  Meal Planner
//
//  Created by Haddawi on 27/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import UIKit

class ShopListViewController: UIViewController {
    
    var filteredShoppingList: [LocalShoppingList] = []
    var filterShopingList: [LocalShoppingList] = []
    let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let shoppingListTableView = UITableView()
        shoppingListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        return shoppingListTableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchBarShoppingList = UISearchController(searchResultsController: nil)
        
        searchBarShoppingList.searchResultsUpdater = self
        
        searchBarShoppingList.obscuresBackgroundDuringPresentation = false
        searchBarShoppingList.searchBar.placeholder = "Cari daftar belanja .."
        searchBarShoppingList.searchBar.sizeToFit()
        searchBarShoppingList.searchBar.searchBarStyle = .prominent
        
        return searchBarShoppingList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Daftar Belanja"
        navigationItem.searchController = searchController
        
        fetchShoppingList()
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        fetchShoppingList()
        self.tableView.reloadData()
    }
    
    func fetchShoppingList() {
        filterShopingList = []
        let tempShoppingList = ShoppingList.fetchAll(viewContext: getViewContext())
        
        for shoppingList in tempShoppingList {
            let shopingItems: [ShoppingItem] = shoppingList.shopping_item?.allObjects as! [ShoppingItem]
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
                arrQtyUnit[index].qty += newQtyUnit.qty
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
    
    func filterContentForSearchText(searchText: String) {
        filteredShoppingList = filterShopingList.filter({ (localShoppingList: LocalShoppingList) -> Bool in
            
            if !isSearchBarEmpty() {
                return localShoppingList.shopping_tag.lowercased().removeDashSymbols().contains(searchText.lowercased())
            } else {
                return false
            }
        })
        
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!isSearchBarEmpty())
    }
}
