//
//  String+Extension.swift
//  Meal Planner
//
//  Created by Fandrian Rhamadiansyah on 20/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
