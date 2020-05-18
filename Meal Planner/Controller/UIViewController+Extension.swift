//
//  UIViewController+Extension.swift
//  Meal Planner
//
//  Created by Rahmat Zulfikri on 15/05/20.
//  Copyright © 2020 Team13. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func getViewContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        return container!.viewContext
    }
}
