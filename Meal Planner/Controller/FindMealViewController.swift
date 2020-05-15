//
//  FindMealViewController.swift
//  Meal Planner
//
//  Created by Fandrian Rhamadiansyah on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class FindMealViewController: UIViewController {
    
    var selectedCategory = CategoryEnum.ayam
    
    let resep: [Recipe] = categories.getRecipeByCategory(category: .ayam)!

    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var findMealViewController: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = selectedCategory.rawValue
        findMealViewController.delegate = self
        findMealViewController.dataSource = self
        // Do any additional setup after loading the view.
    }
    

}

extension FindMealViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resep.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindMealCell", for: indexPath) as! FindMealCollectionViewCell
        print(resep.count)
//        print(resep[0].name)
        cell.backgroundColor = .green
        cell.labelRecipeTitle.text = resep[indexPath.row].name
        return cell
    }
    
}

extension FindMealViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("SDASD")
//            print(mealCategories[indexPath.row].rawValue)
//            selectCategory = mealCategories[indexPath.row]
//            performSegue(withIdentifier: "toFindMeal", sender: self)
    }

}
