//
//  Aggregate.swift
//  For
//
//  Created by Iñigo Alonso on 21/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class Saving: NSObject, NSCoding {
    
    // MARK: Properties
    
    var aggregate: Double
    var currency: String
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("saving")
    
    
    
    // MARK: Initialization
    
    init?(aggregate: Double, currency: String) {
        self.aggregate = aggregate
        self.currency = currency
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if aggregate < 0 || currency.isEmpty {
            return nil
        }
    }
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let aggregateKey = "aggregate"
        static let currencyKey = "currency"
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(aggregate, forKey: PropertyKey.aggregateKey)
        aCoder.encodeObject(currency, forKey: PropertyKey.currencyKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let aggregate = aDecoder.decodeDoubleForKey(PropertyKey.aggregateKey)
        let currency = aDecoder.decodeObjectForKey(PropertyKey.currencyKey) as! String
        
        // Must call designated initilizer.
        self.init(aggregate: aggregate, currency: currency)
    }
    
    // MARK: Functions
    
    static func getDefaultSaving() -> Saving {
        return Saving(aggregate:0.0, currency: "€")!
    }
    
    func add(amountIncrease: Double) {
        self.aggregate = self.aggregate + amountIncrease
    }
}