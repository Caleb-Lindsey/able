//
//  ExpenseField.swift
//  Able
//
//  Created by Caleb Lindsey on 1/29/18.
//  Copyright © 2018 KlubCo. All rights reserved.
//

import UIKit

class ExpenseField : UIView, UITextFieldDelegate {
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
    let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
    
    var titleField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Expense"
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    var barrierView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    var costField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Cost"
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardType = .numberPad
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        // Place Title Field
        titleField.frame = CGRect(x: 0, y: 0, width: self.frame.width * (2/3) - 0.5, height: self.frame.height)
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        titleField.delegate = self
        self.addSubview(titleField)
        
        // Place Barrier View
        barrierView.frame = CGRect(x: titleField.frame.maxX, y: self.frame.height * (1/4), width: 1, height: self.frame.height / 2)
        self.addSubview(barrierView)
        
        // Place Cost Field
        costField.frame = CGRect(x: barrierView.frame.maxX, y: 0, width: self.frame.width * (1/3) - 0.5, height: self.frame.height)
        costField.leftView = paddingView2
        costField.leftViewMode = .always
        costField.delegate = self
        self.addSubview(costField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    func isFilledOut() -> Bool {
        
        if titleField.text != "" && costField.text != "" {
            return true
        } else {
            return false
        }

    }
    
    func cleanFields() {
        
        titleField.text = ""
        costField.text = ""
        titleField.resignFirstResponder()
        costField.resignFirstResponder()
        
    }
    
}























