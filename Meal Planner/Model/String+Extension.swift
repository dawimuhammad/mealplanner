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
    
    func capitalizingEachWords() -> String {
        return capitalized
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeDashSymbols() -> String {
        return self.replace(string: "-", replacement: " ")
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
