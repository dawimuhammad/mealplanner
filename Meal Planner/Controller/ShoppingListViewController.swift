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
    
    var fetchedShoppingList: [ShoppingList] = []
    var shoppingListSortTag: [IngredientsByTags] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Daftar Belanja"
        
        fetchedShoppingList = ShoppingList.fetchAll(viewContext: getViewContext())
        
//        if fetchedShoppingList.count > 0 {
//            prepareSectionTable()
//        }
        
//        prepareSectionTable()
    }
    
    //            if let items: [ShoppingItem] = item.shopping_item!.allObjects as? [ShoppingItem] {
    //                let tagItems = IngredientsByTags(shopping_tag: item.shopping_tag ?? "", ingredients: items)
    //                shoppingListSortTag.append(tagItems)
    //            }
    
    func prepareSectionTable() {
        for item in fetchedShoppingList {
            let shopping_tag = item.shopping_tag


            if let items: [ShoppingItem] = item.shopping_item!.allObjects as? [ShoppingItem] {
                let tagItems = IngredientsByTags(shopping_tag: item.shopping_tag ?? "", ingredients: items)

            }
        }
    }
    
//   func prepareSection() {
//        var prevPlanDate: Date? = nil
//        var planDatas: [Plan] = []
//        for plan in plans {
//            let curPlanDate = plan.plan_date
//
//            if (prevPlanDate == nil) {
//                prevPlanDate = curPlanDate
//            } else {
//                let curDateFormat = DateFormatter()
//                let prevDateFormat = DateFormatter()
//                curDateFormat.dateFormat = "MMM dd,yyyy"
//                prevDateFormat.dateFormat = "MMM dd,yyyy"
//
//                if (curDateFormat.string(from: curPlanDate!) != prevDateFormat.string(from: prevPlanDate!) ) {
//                    let planSection = PlanSection(date: prevPlanDate, plans: planDatas)
//                    plansWithSection.append(planSection)
//                    prevPlanDate = curPlanDate
//                    planDatas = []
//                }
//            }
//
//            planDatas.append(plan)
//        }
//
//        if (prevPlanDate != nil) {
//            let planSection = PlanSection(date: prevPlanDate, plans: planDatas)
//            plansWithSection.append(planSection)
//        }
//
//        print(plansWithSection)
//    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
//        printShoppingList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListSortTag.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let ingredientItem = fetchedShoppingList[indexPath.row]
        
        cell.textLabel?.text = ingredientItem.shopping_tag
        cell.detailTextLabel?.text = "\(ingredientItem.is_complete)"
        cell.imageView?.image = UIImage(named: "checkbox-unmark")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shoppingListSortTag[section].shopping_tag
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "cccc, dd MMM yyyy"
//        return dateFormatterPrint.string(from: plansWithSection[section].date!)
//    }
    
    func filterCurrentDataSource(searchKey: String) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow: ShoppingList = fetchedShoppingList[indexPath.row]
        
        print(selectedRow)
    }
    
    func printShoppingList() {
        for item in fetchedShoppingList {
            if let items: [ShoppingItem] = item.shopping_item!.allObjects as? [ShoppingItem] {
                //assuming you have name your to-many relationship 'sets'
                for item in items {
                    print(item.item_name ?? "")
                }
            }
        }
    }
}
