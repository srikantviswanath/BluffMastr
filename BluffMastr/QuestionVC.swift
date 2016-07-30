//
//  QuestionVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/8/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Firebase

class QuestionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    @IBOutlet weak var roundLbl: UILabel!
    
    var playerScore: Int!
    var answersArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersTable.dataSource = self
        answersTable.delegate = self
        Questions.questions.listenForNextQuestion{
            self.roundLbl.text = "Round: \(Games.roundNumber)"
            self.questionLbl.text = Games.currentQuestionTitle
            Questions.questions.fetchAnswerList{
                ( isPlayerBluffMastr() ? self.constructAnswersArray([Int](1...10)) : self.constructAnswersArray(shuffleArray([Int](1...10))))
                self.answersTable.reloadData()
            }
            self.alertIfPlayerIsBluffMstr()
        }
    }
    
    @IBAction func exitGameBtnClicked(sender: AnyObject) {
        AlertHandler.alert.showActionSheet(ALERT_LEAVE_GAME_TITLE2, destructiveTitle: "Yes", cancelTitle: "No") {
            teardownAfterStartingGame()
            resetStaticVariablesForNewGame()
            self.performSegueWithIdentifier(SEGUE_HOME_GAME, sender: nil)
        }
    }
    
    @IBAction func helpBtnClicked(sender: UIButton) {
        performSegueWithIdentifier(SEGUE_HELP_FOR_QUESTIONVC, sender: nil)
    }
    
    @IBAction func dismissHelp(segue: UIStoryboardSegue) {} //for unwinding the help modal
    
    func alertIfPlayerIsBluffMstr() {
        if isPlayerBluffMastr() {
            AlertHandler.alert.showAlertMsg(STATUS_BLUFFMATR_TITLE, msg: STATUS_BLUFFMATR_MSG)
        } else {
            AlertHandler.alert.showAlertMsg(STATUS_INNOCENT_TITLE, msg: STATUS_INNOCENT_MSG)
        }

    }
    
    func constructAnswersArray(arrayOfInt: [Int]) {
        for answerPos in arrayOfInt {
            answersArray.append(Games.answersDict["\(answerPos)"]!)
        }
    }
    
    /********* Delegates for UITableView **********/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = answersTable.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            cell.configureCell(answersArray[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let answer = answersArray[indexPath.row]
        self.playerScore = Int(evaluateScore(answer))
        performSegueWithIdentifier(SEGUE_FETCH_SCORE, sender: nil)
        Users.myCurrentAnswer = answer
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SEGUE_FETCH_SCORE) {
            let destVC = segue.destinationViewController as! ScoreVC
            destVC.playerScore = self.playerScore
        }
    }
    
}
