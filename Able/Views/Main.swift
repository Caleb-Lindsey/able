//
//  Main.swift
//  Able
//
//  Created by Caleb Lindsey on 1/28/18.
//  Copyright © 2018 KlubCo. All rights reserved.
//

import UIKit

class Main : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Variables
    var cellID = "cellID"
    var dataHandle : DataSource = DataSource()
    var initialIndexPath : IndexPath!
    var gradientView = RadialGradientView()
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    
    var mainTableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        mainTableView.addGestureRecognizer(longpress)
        view.backgroundColor = UIColor.black
        
        let newLayer = CAGradientLayer()
        newLayer.colors = [Global.orangeColor.cgColor, Global.orangeColor2.cgColor]
        newLayer.frame = self.view.frame
        self.view.layer.insertSublayer(newLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        // Place MainTableView
        mainTableView.frame = CGRect(x: 0, y: statusBar.frame.height, width: view.frame.width, height: view.frame.height - statusBar.frame.height)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(ExpenseCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(mainTableView)
        
        dataHandle.calculatePayables(tableView: mainTableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.arrayOfExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ExpenseCell = ExpenseCell(style: UITableViewCellStyle.default, reuseIdentifier: cellID, expense: Global.arrayOfExpenses[indexPath.row])
        if !cell.expense.payable {
            cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(0.015 * Double(indexPath.row)))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView : MainHeader = MainHeader(frame: CGRect(), tableView: mainTableView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height / 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            dataHandle.removeExpense(row: indexPath.row)
            dataHandle.saveExpenses()
            dataHandle.calculatePayables(tableView: mainTableView)
            mainTableView.reloadData()
            
        }
        
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: mainTableView)
        let indexPath = mainTableView.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                initialIndexPath = indexPath
                let cell = mainTableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshopOfCell(inputView: cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                mainTableView
                    .addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != initialIndexPath)) {
                    Global.arrayOfExpenses.insert(Global.arrayOfExpenses.remove(at: initialIndexPath!.row), at: indexPath!.row)
                    mainTableView.moveRow(at: initialIndexPath! as IndexPath, to: indexPath!)
                    dataHandle.calculatePayables(tableView: mainTableView)
                    initialIndexPath = indexPath
                }
            }
        default:
            if initialIndexPath != nil {
                let cell = mainTableView.cellForRow(at: initialIndexPath! as IndexPath) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        self.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
}
    


















