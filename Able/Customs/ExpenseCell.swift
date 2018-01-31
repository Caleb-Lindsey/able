//
//  ExpenseCell.swift
//  Able
//
//  Created by Caleb Lindsey on 1/28/18.
//  Copyright © 2018 KlubCo. All rights reserved.
//

import UIKit

class ExpenseCell : UITableViewCell {
    
    var expense : Expense!
    
    var tabView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    var costLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .right
        return label
    }()
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, expense: Expense) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.expense = expense
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

        // Place Tab View
        tabView.frame = CGRect(x: 0, y: 5, width: 2, height: self.contentView.frame.height - 10)
        self.contentView.addSubview(tabView)
        
        // Place Title Label
        titleLabel.frame = CGRect(x: tabView.frame.maxX + 13, y: self.contentView.frame.height / 2 - 15, width: self.contentView.frame.width / 2, height: 30)
        titleLabel.text = self.expense.title
        self.contentView.addSubview(titleLabel)
        
        // Place costLabel
        costLabel.frame = CGRect(x: titleLabel.frame.maxX + 15, y: 0, width: self.contentView.frame.width / 2 - 45, height: self.contentView.frame.height)
        costLabel.text = "$\((self.expense.cost)!)"
        costLabel.font = UIFont(name: "Helvetica", size: 30)
        self.contentView.addSubview(costLabel)
        
        if self.expense.payable {
            self.tabView.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.white
            self.costLabel.textColor = UIColor.white
        } else {
            self.tabView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            self.titleLabel.textColor = UIColor.black.withAlphaComponent(0.35)
            self.costLabel.textColor = UIColor.black.withAlphaComponent(0.35)
            
        }
        
        
    }
    
    
}










