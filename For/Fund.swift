//
//  Funds.swift
//  For
//
//  Created by Iñigo Alonso on 24/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class Fund: NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String
    var monetaryGoal: Double
    var shares  = [Share]()
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("funds")
    
    
    
    // MARK: Initialization
    
    init?(name: String, monetaryGoal: Double) {
        self.name = name
        self.monetaryGoal = monetaryGoal
        
        super.init()
        
        // Initialization should fail if there is no name or if the price is negative.
        if name.isEmpty || monetaryGoal < 0 {
            return nil
        }
    }
    
    convenience init?(name: String, monetaryGoal: Double, shares: [Share]) {
        // Must call designated initilizer.
        self.init(name: name, monetaryGoal: monetaryGoal)
        
        self.shares = shares
    }
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let monetaryGoalKey = "monetaryGoal"
        static let sharesKey = "shares"
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeDouble(monetaryGoal, forKey: PropertyKey.monetaryGoalKey)
        aCoder.encodeObject(shares, forKey: PropertyKey.sharesKey)
        //aCoder.encodeArrayOfObjCType(Share, count: share, at: UnsafePointer<Void>)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let monetaryGoal = aDecoder.decodeDoubleForKey(PropertyKey.monetaryGoalKey)
        let shares = aDecoder.decodeObjectForKey(PropertyKey.sharesKey) as! [Share]
        
        // Must call designated initilizer.
        self.init(name: name, monetaryGoal: monetaryGoal, shares: shares)
    }
    
    // MARK: Functions
    
    // Devuelve la suma total de las aportaciones de este Fund
    func getAggregate() -> Double {
        return getAggregateForSpecificShares(self.shares)
    }
    
    // Devuelve la suma total de todas las aportaciones pasadas por parámetro
    func getAggregateForSpecificShares(shares: [Share]) -> Double {
        var aggregate = 0.0
        for share in shares {
            aggregate += share.amount
        }
        return aggregate
    }
    
    // Devuelve el % de progreso con respecto al monetaryGoal hecho con las aportaciones privadas a este fondo
    func getProgressForPrivateShares() -> Double {
        if monetaryGoal <= 0 {
            return 0
        }
        
        let rawPercentage = (getAggregate() * 100.0) / self.monetaryGoal
        //return Int(rawPercentage) ?? 0
        return rawPercentage
    }
    
    // Devuelve el % de progreso con respecto al monetaryGoal hecho con las aportaciones que s epasan por parámetro (normalmente las del fondo común)
    func getProgressForSpecificShares(generalShares: [Share]) -> Double {
        if monetaryGoal <= 0 {
            return 0
        }
        
        let rawPercentage = (getAggregateForSpecificShares(generalShares) * 100.0) / self.monetaryGoal
        //return Int(rawPercentage) ?? 0
        return rawPercentage
    }
    
    // Devuelve el progreso de la suma de las Shares privadas de este Fund y las Shares especificas pasadas pro parámetro
    func getProgress(generalShares: [Share]) -> Double {
        return getProgressForSpecificShares(generalShares) + getProgressForPrivateShares()
    }
    
    // Metodo que general el Fondo común por defecto
    static func getGeneralFund() -> Fund {
        return Fund(name: "General", monetaryGoal: 0)!
    }
}
