//
//  SaveMoneyViewController.swift
//  For
//
//  Created by Iñigo Alonso on 21/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class SaveMoneyViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: Properties
    var amountIncrease = 0.0
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self

        // Enable the Save button only if the text field has a valid Meal name.
        checkValidAmount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Resign the text field’s first-responder status and hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // The first line calls checkValidMealName() to check if the text field has text in it, which enables the Save button if it does. 
        checkValidAmount()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidAmount() {
        saveButton.enabled = getAmountFromTextField() > 0
    }

    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            amountIncrease = getAmountFromTextField()
        }
    }
    
    // MARK: Functions
    
    func getAmountFromTextField() -> Double{
        // Si es nil devuelve ""
        var text = amountTextField.text ?? ""
        // Sustituimos las , por .
        text = text.stringByReplacingOccurrencesOfString(",", withString: ".")
        return (text as NSString).doubleValue
    }
    

}
