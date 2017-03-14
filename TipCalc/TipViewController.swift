//
//  ViewController.swift
//  TipCalc
//
//  Created by praneeth puligundla on 3/1/17.
//  Copyright © 2017 praneeth puligundla. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    let tipPercentages=[0.18,0.2,0.25]
    
    let limitLength=10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        /*
         Setting currency based on region
         */
        let locale = Locale.current
        let currencySymbol:String = locale.currencySymbol!
        billField.placeholder = currencySymbol
        totalLabel.text = currencySymbol
        tipLabel.text = currencySymbol
        self.billField.becomeFirstResponder()
    }
    /**
     Limit the bill text field to 10
    */
    @objc(textField:shouldChangeCharactersInRange:replacementString:) func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = billField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    /**
     Calculates the tip and appends currency symbol to tip and total
     */
    func calculateTipValue() {
        let bill=Double(billField.text!) ?? 0
        let tip=Double(bill * tipPercentages[tipControl.selectedSegmentIndex])
        let total=Double(bill+tip)
        let locale = Locale.current
        let currencySymbol:String = locale.currencySymbol!
        tipLabel.text = String(format: "%@%.2f", currencySymbol,tip)
        totalLabel.text = String(format: "%@%.2f", currencySymbol,total)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        calculateTipValue()
    }
    
    @IBAction func dynamicTipCalculate(_ sender: Any) {
        calculateTipValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tipdefaultIndex=defaults.integer(forKey: "defaultTipPercentage")
        tipControl.selectedSegmentIndex = tipdefaultIndex;
        /*
         Check time and load/clear bill amount
         */
        let amount = defaults.double(forKey: "amount")
        let startTime:UInt64 = UInt64(defaults.integer(forKey: "startTime"))
        if(startTime != 0){
            let endTime:UInt64 = (DispatchTime.now().uptimeNanoseconds)
            let timeDifference = (endTime - startTime)
            print ("time")
            print(timeDifference / UInt64(1.67 * 1_000_000_000_00))
            print ("amount" )
            print( amount)
            if(amount != 0 && (timeDifference / UInt64(1.67 * 1_000_000_000_00) < 1)){
                billField.text = String(amount)
                calculateTipValue()
            }else{
                let locale = Locale.current
                let currencySymbol:String = locale.currencySymbol!
                billField.placeholder = currencySymbol
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.set(Double(billField.text!) ?? 0, forKey: "amount")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        defaults.set(DispatchTime.now().uptimeNanoseconds, forKey: "startTime")
    }
}

