//
//  ViewController.swift
//  For
//
//  Created by Iñigo Alonso on 21/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    var saving = Saving(aggregate: 0.0, currency: "€")!
    var products = [Product]()

    @IBOutlet weak var aggregateLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTableView.delegate = self
        productTableView.dataSource = self
        
        
        loadData()
        
        updateAggregate()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Por defecto el UITableViewController tiene la propiedad clearsSelectedOnViewWillAppear puesta a YES y hace que se deseleccionen las celdas cuando vuelve a aparecer. En este caso, como esta clase no hereda de UITableViewController se puede replicar este mismo comportamiento de la siguiente forma
        if let selectedIndexPath = productTableView.indexPathForSelectedRow {
            productTableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
        
    }
    
    func loadSampleProducts() {
        let name1 = "PS4"
        let price1 = 399.0
        let product1 = Product(name: name1, price: price1)!
        
        let name2 = "AppleWatch"
        let price2 = 475.0
        let product2 = Product(name: name2, price: price2)!
        
        let name3 = "Fallout 4"
        let price3 = 64.0
        let product3 = Product(name: name3, price: price3)!
        
        products += [product1, product2, product3]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Navigation
    
    @IBAction func unwindToMainView(sender: UIStoryboardSegue) {
        
        
        if let sourceViewController = sender.sourceViewController as? ProductViewController, product = sourceViewController.product {
            if let selectedIndexPath = productTableView.indexPathForSelectedRow {
                // Update an existing product.
                products[selectedIndexPath.row] = product
                productTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new product.
                let newIndexPath = NSIndexPath(forRow: products.count, inSection: 0)
                products.append(product)
                productTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // Save the products.
            saveProducts()
        }else if let sourceViewController = sender.sourceViewController as? SaveMoneyViewController {
            
            let amountIncrease = sourceViewController.amountIncrease
            
            // Add the new amountIncrease
            saving.add(amountIncrease)
            
            updateAggregate()
            
            saveSaving()
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let productDetailViewController = segue.destinationViewController as! ProductViewController
            // Get the cell that generated this segue.
            if let selectedProductCell = sender as? ProductTableViewCell {
                let indexPath = productTableView.indexPathForCell(selectedProductCell)!
                let selectedProduct = products[indexPath.row]
                productDetailViewController.product = selectedProduct
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new product.")
        }
    }
    
    
    // MARK: - Table view data source
    
    // Esto determina en numero de secciones. LAs secciones son los titulos que aparecen encima de grupos de elementos en la lista. Ej: Contactos A, B, C...
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ProductTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProductTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let product = products[indexPath.row]
        
        cell.productNameLabel.text = product.name
        cell.productPriceLabel.text = "\(product.price)"
        // TODO: Poner el progreso en barra y %
        let progressPercentage = product.getProgress(saving)
        let progressPerone = Float(progressPercentage) / 100.0
        cell.progressPercentageLabel.text = "\(progressPercentage)%"
        cell.progressBar.setProgress(progressPerone, animated: true)
        
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            products.removeAtIndex(indexPath.row)
            saveProducts()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    
    // MARK: NSCoding
    func saveProducts() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(products, toFile: Product.ArchiveURL.path!)
        
        // Mensaje de error en caso de que no se guarde bien
        if !isSuccessfulSave {
            print("Failed to save products...")
        }
    }
    
    func loadProducts() -> [Product]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Product.ArchiveURL.path!) as? [Product]
    }
    
    func saveSaving() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(saving, toFile: Saving.ArchiveURL.path!)
        
        // Mensaje de error en caso de que no se guarde bien
        if !isSuccessfulSave {
            print("Failed to save the saving...")
        }
    }
    
    func loadSaving() -> Saving? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Saving.ArchiveURL.path!) as? Saving
    }
    
    func loadData(){
        // Load any saved products, otherwise load sample data.
        if let loadedSaving = loadSaving() {
            self.saving = loadedSaving
        } else {
            self.saving = Saving.getDefaultSaving()
        }
        
        
        // Load any saved products, otherwise load sample data.
        if let savedProducts = loadProducts() {
            products += savedProducts
        } else {
            // Load the sample data.
            loadSampleProducts()
        }
    }
    
    // MARK: Functions
    
    
    
    func updateAggregate(){
        aggregateLabel.text = "\(saving.aggregate)\(saving.currency)"
        productTableView.reloadData()
    }
}

