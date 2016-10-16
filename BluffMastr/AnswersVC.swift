//
//  AnswersVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class AnswersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var answersTable: UITableView!
    
    var answersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersTable.delegate = self
        answersTable.dataSource = self
        constructAnswersArray()
    }
    
    func constructAnswersArray() {
        for answerPos in 1...10 {
            answersArray.append(Games.answersDict["\(answerPos)"]!)
        }
        answersArray = answersArray.reverse()
    }
    
    /* UITableView delegate methods */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = answersTable.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            if Users.myCurrentAnswer == nil { //When bluffMastr cheats, myCurrentAnswer is not set yet
                cell.configureCell(answersArray[indexPath.row])
                return cell
            } else {
                switch answersArray[indexPath.row] {
                case Users.myCurrentAnswer!:
                    cell.configureCell(answersArray[indexPath.row], score: "\(10 - indexPath.row)")
                    cell.backgroundColor = UIColor(netHex: COLOR_ELECTED_ANSWER)
                    cell.MainLbl.textColor = UIColor.whiteColor()
                    cell.scoreLbl.textColor = UIColor.whiteColor()
                default:
                    cell.configureCell(answersArray[indexPath.row], score: "\(10 - indexPath.row)")
                }
                return cell
            }
            
        } else {
            return UITableViewCell()
        }
    }
    
    
}
