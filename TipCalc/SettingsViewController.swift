//
//  TipSettingsview.swift
//  TipCalc
//
//  Created by praneeth puligundla on 3/11/17.
//  Copyright © 2017 praneeth puligundla. All rights reserved.
//

import Foundation
import UIKit


class TipSettingsController: UIViewController{
    
    @IBOutlet weak var DefaultTipPercentage: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        DefaultTipPercentage.selectedSegmentIndex = defaults.integer(forKey: "defaultTipPercentage")
    }
    
    @IBAction func setDefault(_ sender: Any) {
        defaults.set(DefaultTipPercentage.selectedSegmentIndex, forKey: "defaultTipPercentage")
        defaults.synchronize()
    }
}
