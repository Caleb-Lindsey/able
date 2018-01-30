//
//  MainHeader.swift
//  Able
//
//  Created by Caleb Lindsey on 1/28/18.
//  Copyright © 2018 KlubCo. All rights reserved.
//

import UIKit

class MainHeader : UIView {
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
    var dataHandle : DataSource = DataSource()
    var tableView : UITableView!
    
    var incomeButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        button.titleLabel?.font = UIFont(name: "helvetica", size: 65)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(incomeTapped), for: .touchUpInside)
        return button
    }()
    
    var addExpensePlus : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addExpense), for: .touchUpInside)
        return button
    }()
    
    var expenseField : ExpenseField = {
        let textField = ExpenseField()
        return textField
    }()
    
    var newIncomeField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 8
        textField.layer.opacity = 0
        textField.placeholder = "Income This Week"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    var doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Budget", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        button.titleLabel?.font = UIFont(name: "helvetica", size: 20)
        button.layer.borderWidth = 0.8
        button.layer.cornerRadius = 8
        button.titleLabel?.textAlignment = .center
        button.layer.opacity = 0
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    var cancelButton : UIButton = {
        let button = UIButton()
        button.layer.opacity = 0
        button.setImage(#imageLiteral(resourceName: "x"), for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    init(frame: CGRect, tableView: UITableView) {
        super.init(frame: frame)
        backgroundColor = Global.orangeColor
        self.tableView = tableView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        // Place Income Button
        incomeButton.frame = CGRect(x: 0, y: -1, width: self.frame.width, height: self.frame.height / 2)
        incomeButton.setTitle("$\(Global.userIncome)", for: .normal)
        self.addSubview(incomeButton)
        
        // Place Expense Field
        expenseField.frame = CGRect(x: 0, y: self.frame.height - 75, width: self.frame.width * (4/5), height: 75)
        self.addSubview(expenseField)
        
        // Place Add Expense Plus Button
        addExpensePlus.frame = CGRect(x: expenseField.frame.maxX, y: expenseField.frame.origin.y, width: self.frame.width * (1/5), height: expenseField.frame.height)
        self.addSubview(addExpensePlus)
        
        // Place Done Button
        doneButton.frame = CGRect(x: self.frame.width - 80 - 15, y: self.frame.height - 30 - 15, width: 80, height: 30)
        self.addSubview(doneButton)
        
        // Place Cancel Button
        cancelButton.frame = CGRect(x: self.frame.width - 22 - 15, y: 15, width: 22, height: 22)
        self.addSubview(cancelButton)
        
        // Place New Income Field
        newIncomeField.frame = CGRect(x: self.frame.width * (1/4), y: self.frame.height / 2 - 30, width: self.frame.width / 2, height: 60)
        newIncomeField.leftView = paddingView
        newIncomeField.leftViewMode = .always
        self.addSubview(newIncomeField)
        
        
    }
    
    @objc func incomeTapped() {
        
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromTop, animations: {
            
            self.incomeButton.layer.opacity = 0
            self.expenseField.layer.opacity = 0
            self.addExpensePlus.layer.opacity = 0
            self.doneButton.layer.opacity = 1
            self.cancelButton.layer.opacity = 1
            self.newIncomeField.layer.opacity = 1
            
        }, completion: { (finished: Bool) in
            
            
            
        })
        
    }
    
    @objc func doneTapped() {
        
        if newIncomeField.text != "" {
            if let amount = Int(newIncomeField.text!) {
                Global.userIncome = amount
                incomeButton.setTitle("$\(amount)", for: .normal)
                dataHandle.calculatePayables(tableView: tableView)
            }
        } else {
            
        }
        
        cancelTapped()
        
    }
    
    @objc func cancelTapped() {
        
        newIncomeField.resignFirstResponder()
        newIncomeField.text = ""
        
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            
            self.incomeButton.layer.opacity = 1
            self.expenseField.layer.opacity = 1
            self.addExpensePlus.layer.opacity = 1
            self.doneButton.layer.opacity = 0
            self.cancelButton.layer.opacity = 0
            self.newIncomeField.layer.opacity = 0
            
        }, completion: { (finished: Bool) in
            
            
            
        })
        
    }
    
    @objc func addExpense() {
        
        if expenseField.isFilledOut() {
            
            let newExpense : Expense = Expense(title: expenseField.titleField.text!, cost: Int(expenseField.costField.text!)!)
            dataHandle.appendExpense(expense: newExpense)
            dataHandle.saveExpenses()
            dataHandle.calculatePayables(tableView: tableView)
            tableView.reloadData()
            expenseField.cleanFields()
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    
}













