//
//  Share.swift
//  For
//
//  Created by Iñigo Alonso on 24/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class Share: NSObject, NSCoding {
    
    // MARK: Properties
    var amount: Double
    var title: String?
    var creationDate: NSDate
    
    // MARK: Initialization
    init(amount: Double, title: String?, creationDate: NSDate) {
        self.amount = amount
        self.title = title
        self.creationDate = creationDate
        
        super.init()
    }
    
    // MARK: Types
    
    struct PropertyKey {
        static let amountKey = "amount"
        static let titleKey = "title"
        static let creationDateKey = "creationDate"
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(amount, forKey: PropertyKey.amountKey)
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(creationDate, forKey: PropertyKey.creationDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let amount = aDecoder.decodeDoubleForKey(PropertyKey.amountKey)
        // Because title is an optional property of Share, use conditional cast.
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as? String
        let creationDate = aDecoder.decodeObjectForKey(PropertyKey.creationDateKey) as! NSDate
        
        // Must call designated initilizer.
        self.init(amount: amount, title: title, creationDate: creationDate)
    }
}
