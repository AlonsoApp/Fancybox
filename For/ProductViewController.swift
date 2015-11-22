//
//  ProductViewController.swift
//  For
//
//  Created by Iñigo Alonso on 21/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: Properties
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by `MainViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new product.
    */
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        priceTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let product = product {
            navigationItem.title = product.name
            nameTextField.text   = product.name
            priceTextField.text = "\(product.price)"
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidProductInfo()
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
        checkValidProductInfo()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidProductInfo() {
        let productName = nameTextField.text ?? ""
        saveButton.enabled = getPriceFromTextField() > 0 && !productName.isEmpty
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddProductMode = presentingViewController is UINavigationController
        if isPresentingInAddProductMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            // The code within the else clause executes a method called popViewControllerAnimated, which pops the current view controller (meal scene) off the navigation stack of navigationController and performs an animation of the transition.
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            let name = nameTextField.text ?? ""
            let price = getPriceFromTextField()
            
            product = Product(name: name, price: price)
        }
    }
    
    // MARK: Functions
    
    func getPriceFromTextField() -> Double{
        // Si es nil devuelve ""
        var text = priceTextField.text ?? ""
        // Sustituimos las , por .
        text = text.stringByReplacingOccurrencesOfString(",", withString: ".")
        return (text as NSString).doubleValue
    }

}
