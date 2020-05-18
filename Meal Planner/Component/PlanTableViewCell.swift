//
//  PlanTableViewCell.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 19/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
