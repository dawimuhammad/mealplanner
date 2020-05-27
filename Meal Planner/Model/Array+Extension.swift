//
//  Array+Extension.swift
//  Meal Planner
//
//  Created by Haddawi on 27/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation

extension Array where Element: ShoppingItem {
    func removeDuplicates() -> String {
        var result: [Element] = []
        var resultString: String = ""

        for value in self {
//            if result.contains(where: { $0.item_name == value.item_name }) {
//                value.item_qty += value.item_qty
//            } else {
//                result.append(value)
//            }

//            if let foo = result.first(where: {$0.item_name == value.item_name}) {
//                foo.item_qty += value.item_qty
//            } else {
//                result.append(value)
//            }
            result.append(value)
        }

        for generatedItem in result {
            var separator = ", "
            if generatedItem == result.last {
               separator = ""
            }

            resultString += "\(generatedItem.item_qty) \(generatedItem.item_unit ?? "") \(separator)"
        }

        return resultString
    }
}
