//
//  Expense.swift
//  Able
//
//  Created by Caleb Lindsey on 1/28/18.
//  Copyright © 2018 KlubCo. All rights reserved.
//

import Foundation

class Expense : NSObject, NSCoding {
    
    var title : String!
    var cost : Int!
    var payable : Bool = false
    
    init(title: String, cost: Int) {
        self.title = title
        self.cost = cost
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObject(forKey: "Title") as! String
        self.cost = aDecoder.decodeObject(forKey: "Cost") as! Int
        self.payable = aDecoder.decodeBool(forKey: "Payable")
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Expense {
        
        self.title = aDecoder.decodeObject(forKey: "Title") as! String
        self.cost = aDecoder.decodeObject(forKey: "Cost") as! Int
        self.payable = aDecoder.decodeBool(forKey: "Payable")
        
        return self
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "Title")
        aCoder.encode(cost, forKey: "Cost")
        aCoder.encode(payable, forKey: "Payable")
        
    }
    
}











