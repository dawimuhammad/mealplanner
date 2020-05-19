//
//  UIColor+Extension.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 19/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / CGFloat(255)
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / CGFloat(255)
                    b = CGFloat((hexNumber & 0x0000FF)) / CGFloat(255)
                    self.init(red: r, green: g, blue: b, alpha: CGFloat(1))
                    return
                }
            }
        }

        return nil
    }
}
