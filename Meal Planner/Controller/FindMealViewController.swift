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
    
    var resep: [Recipe] = []
    var selectRecipe = categories.getRecipeByCategory(category: .ayam)![0]
    
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var findMealViewController: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = selectedCategory.rawValue
        findMealViewController.delegate = self
        findMealViewController.dataSource = self
        resep = categories.getRecipeByCategory(category: selectedCategory)!
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetailMeal" {
                if let destinationVC = segue.destination as? DetailMealViewController{
                    destinationVC.recipe = selectRecipe
                }
            }
        }
    }
    
}

//MARK: - Find Meal View Controller

extension FindMealViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resep.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindMealCell", for: indexPath) as! FindMealCollectionViewCell
        print(resep.count)
        cell.labelRecipeTitle.text = resep[indexPath.row].name
        cell.labelRecipeDetail.text = "\(resep[indexPath.row].duration!) menit - \(resep[indexPath.row].portion!) orang"
        cell.imageMeal.image = UIImage(named: resep[indexPath.row].photo!)
        return cell
    }
    
}

extension FindMealViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRecipe = resep[indexPath.row]
        performSegue(withIdentifier: "toDetailMeal", sender: self)
    }
    
}
