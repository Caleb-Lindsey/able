//
//  DataSource.swift
//  Able
//
//  Created by Caleb Lindsey on 1/28/18.
//  Copyright © 2018 KlubCo. All rights reserved.
//

import UIKit

struct Global {
    
    static var userIncome : Int = 0
    static var arrayOfExpenses : [Expense] = [Expense]()
    
    // Color Pallette
    static var orangeColor = UIColor(displayP3Red: 214/255, green: 110/255, blue: 20/255, alpha: 1)
    
}

class DataSource {
    
    func fillMockData() {
        
        let expense1 : Expense = Expense(title: "Car Payment", cost: 249)
        let expense2 : Expense = Expense(title: "Groceries", cost: 35)
        let expense3 : Expense = Expense(title: "Gas", cost: 28)

        Global.arrayOfExpenses = [expense1, expense2, expense3]
        
    }
    
    func appendExpense(expense: Expense) {
        
        if Global.arrayOfExpenses.isEmpty {
            Global.arrayOfExpenses = [expense]
        } else {
            Global.arrayOfExpenses.append(expense)
        }
        
    }
    
    func removeExpense(row: Int) {
        
        Global.arrayOfExpenses.remove(at: row)
        
    }
    
    func saveExpenses() {
        let data = NSKeyedArchiver.archivedData(withRootObject: Global.arrayOfExpenses)
        UserDefaults.standard.set(data, forKey: "Expenses")
        print("Expenses Saved")
    }
    
    func fillExpenseData()
    {
        print("Filling Expenses")
        if let data = UserDefaults.standard.object(forKey: "Expenses") as? NSData {
            Global.arrayOfExpenses = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Expense]
        }
    }
    
    func calculatePayables(tableView: UITableView) {
        print("calculating....")
        var currentBudget : Int = Global.userIncome
        var count : Int = 0
        
        for thisExpense in Global.arrayOfExpenses {
            
            if thisExpense.cost > currentBudget {
                Global.arrayOfExpenses[count].payable = false
            } else {
                Global.arrayOfExpenses[count].payable = true
            }
            
            currentBudget -= thisExpense.cost
            count += 1
            
        }
        
        tableView.reloadData()
        
    }
    
}















