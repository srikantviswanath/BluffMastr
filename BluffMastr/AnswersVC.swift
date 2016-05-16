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
            switch answersArray[indexPath.row] {
            case Games.answersDict["1"]!:
                cell.configureCell(answersArray[indexPath.row], leadingLbl: MOST_COMMON)
            case Games.answersDict["10"]!:
                cell.configureCell(answersArray[indexPath.row], leadingLbl: LEAST_COMMON)
            default:
                cell.configureCell(answersArray[indexPath.row])
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
