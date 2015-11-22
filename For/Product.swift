//
//  Product.swift
//  For
//
//  Created by Iñigo Alonso on 21/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class Product: NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String
    var price: Double
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("products")
    
    
    
    // MARK: Initialization
    
    init?(name: String, price: Double) {
        self.name = name
        self.price = price
        
        super.init()
        
        // Initialization should fail if there is no name or if the price is negative.
        if name.isEmpty || price < 0 {
            return nil
        }
    }
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let priceKey = "price"
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeDouble(price, forKey: PropertyKey.priceKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let price = aDecoder.decodeDoubleForKey(PropertyKey.priceKey)
        
        // Must call designated initilizer.
        self.init(name: name, price: price)
    }
    
    // MARK: Functions
    
    func getProgress(saving: Saving) -> Int {
        let rawPercentage = (saving.aggregate * 100.0) / self.price
        return Int(rawPercentage) ?? 0
    }
}