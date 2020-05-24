//
//  CategoryViewController.swift
//  Meal Planner
//
//  Created by Fandrian Rhamadiansyah on 08/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    
    let mealCategories = CategoryEnum.allCases
    var selectCategory = CategoryEnum.ayam
    var selectRecommendation = categories.getRecipeByCategory(category: .ayam)![0]
    
    let recommendation = categories.getRecipeByCategory(category: .ayam)!
    
    var delegate: MyDetailMealDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden = true

        //try check save data
        let savedData = Plan.fetchAll(viewContext: getViewContext())
        for plan in savedData {
            print("plan date: \(plan.plan_date!)")
            print("recipe id: \(plan.recipe_id!)")
            print("recipe name: \(plan.recipe_name!)")
            print("recipe photo: \(plan.recipe_photo!)")
            print("\n\n")
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toFindMeal" {
                if let destinationVC = segue.destination as? FindMealViewController{
                    destinationVC.selectedCategory = selectCategory
                    destinationVC.delegate = self.delegate
                }
            } else if identifier == "toDetailMeal" {
                if let destinationVC = segue.destination as? DetailMealViewController{
                    destinationVC.recipe = selectRecommendation
                    destinationVC.delegate = self.delegate
                }
            }
        }
    }
    
}

//MARK: - Meal Category Collection View

extension CategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return mealCategories.count
        }
        return recommendation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            cellA.labelCategory.text = mealCategories[indexPath.row].rawValue.capitalizingFirstLetter()
            switch mealCategories[indexPath.row] {
            case .ayam:
                cellA.imageCategory.image = #imageLiteral(resourceName: "CategoryAyam")
            case .sapi:
                cellA.imageCategory.image = #imageLiteral(resourceName: "CategorySapi")
            case .ikan:
                cellA.imageCategory.image = #imageLiteral(resourceName: "CategoryIkan")
            case .sayur:
                cellA.imageCategory.image = #imageLiteral(resourceName: "CategorySayuran")
            case .babi:
                cellA.imageCategory.image = #imageLiteral(resourceName: "CategoryBabi")
            default:
                cellA.imageCategory.image = #imageLiteral(resourceName: "CategoryLainnya")
            }
            return cellA
        } else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCollectionViewCell
            print("cell ok")
            cellB.recommendationTitleCell.text = recommendation[indexPath.row].name
            cellB.recommendationDetailCell.text = "\(recommendation[indexPath.row].duration!) menit - \(recommendation[indexPath.row].portion!) orang"
            cellB.recommendationImage.image = UIImage(named: recommendation[indexPath.row].photo!)
            cellB.recommendationImage.layer.cornerRadius = 10
            return cellB
        }
        
        
    }
    
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            print("SDASD123123")
            print(mealCategories[indexPath.row].rawValue)
            selectCategory = mealCategories[indexPath.row]
            performSegue(withIdentifier: "toFindMeal", sender: self)
        } else {
            print("SDASD123123")
//            print(recommendation[indexPath.row].rawValue)
            selectRecommendation = recommendation[indexPath.row]
            performSegue(withIdentifier: "toDetailMeal", sender: self)
        }
        
    }
    
}



