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
    var searchedRecipe: [Recipe] = []
    var searching : Bool = false
    
    

    
    var delegate: MyDetailMealDelegate?
    

    @IBOutlet weak var findMealCollectionView: UICollectionView!
    @IBOutlet weak var findMealSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory.rawValue.capitalizingFirstLetter()
//        labelTitle.text = selectedCategory.rawValue
        findMealCollectionView.delegate = self
        findMealCollectionView.dataSource = self
        findMealSearchBar.delegate = self
        resep = categories.getRecipeByCategory(category: selectedCategory)!
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetailMeal" {
                if let destinationVC = segue.destination as? DetailMealViewController{
                    destinationVC.recipe = selectRecipe
                    destinationVC.delegate = delegate
                }
            }
        }
    }
    
}

//MARK: - Find Meal View Controller

extension FindMealViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedRecipe.count
        } else {
           return resep.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindMealCell", for: indexPath) as! FindMealCollectionViewCell
        print(resep.count)
        if searching {
            cell.labelRecipeTitle.text = searchedRecipe[indexPath.row].name
            cell.labelRecipeDetail.text = "\(searchedRecipe[indexPath.row].duration!) menit - \(searchedRecipe[indexPath.row].portion!) orang"
            cell.imageMeal.image = UIImage(named: searchedRecipe[indexPath.row].photo!)
            return cell
        } else {
            cell.labelRecipeTitle.text = resep[indexPath.row].name
            cell.labelRecipeDetail.text = "\(resep[indexPath.row].duration!) menit - \(resep[indexPath.row].portion!) orang"
            cell.imageMeal.image = UIImage(named: resep[indexPath.row].photo!)
            return cell
        }
        
    }
    
}

extension FindMealViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searching {
            selectRecipe = searchedRecipe[indexPath.row]
            performSegue(withIdentifier: "toDetailMeal", sender: self)
        } else {
            selectRecipe = resep[indexPath.row]
            performSegue(withIdentifier: "toDetailMeal", sender: self)
        }
    }

}

//MARK: - Search Bar Delegate

extension FindMealViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            print("search")
            //reload your data source if necessary
            searching = true
        } else {
            print ("do something?")
            searching = false
        }
        self.findMealSearchBar.endEditing(true)
        self.findMealCollectionView?.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("edit")
        if(searchText.isEmpty){
            print("empty")
            //reload your data source if necessary
            searching = false
            self.findMealCollectionView?.reloadData()
        } else {
            searching = true
            searchedRecipe = resep.filter { ($0.name?.lowercased().contains(searchText.lowercased()))! }
            self.findMealCollectionView?.reloadData()
        }
    }
    
}

