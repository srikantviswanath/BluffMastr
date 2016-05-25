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
    @IBOutlet weak var answerSubmitted: UITextField!
    @IBOutlet weak var answersTable: UITableView!
    
    var playerScore: Int!
    var answersArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersTable.dataSource = self
        answersTable.delegate = self
        Questions.questions.listenForNextQuestion{
            self.questionLbl.text = Games.currentQuestionTitle
            Questions.questions.fetchAnswerList{
                ( isPlayerBluffMastr() ? self.constructAnswersArray([Int](1...10)) : self.constructAnswersArray(shuffleArray([Int](1...10))))
                self.answersTable.reloadData()
            }
            self.alertIfPlayerIsBluffMstr()
        }
    }
    
    func alertIfPlayerIsBluffMstr() {
        if isPlayerBluffMastr() {
            ErrorHandler.errorHandler.showErrorMsg(STATUS_BLUFFMATR_TITLE, msg: STATUS_BLUFFMATR_MSG)
        } else {
            ErrorHandler.errorHandler.showErrorMsg(STATUS_INNOCENT_TITLE, msg: STATUS_INNOCENT_MSG)
        }

    }
    
    @IBAction func cheat(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier(SEGUE_BLUFFMASTR_CHEAT, sender: nil)
    }
    
    @IBAction func stopCheating(segue: UIStoryboardSegue) {} //For unwinding the modal segue AnswersVC
    
    @IBAction func submitPlayerAnswer(sender: UIButton!) {
        if let answer = answerSubmitted.text where answer != "" {
            self.playerScore = Int(evaluateScore(answer))
            if self.playerScore != ANSWER_ABSENT_FROM_LIST {
                performSegueWithIdentifier(SEGUE_FETCH_SCORE, sender: nil)
                Users.myCurrentAnswer = answer
            }
            else {ErrorHandler.errorHandler.showErrorMsg(ERR_TYPO_TITLE, msg: ERR_TYPO_MSG)}
        } else {
            ErrorHandler.errorHandler.showErrorMsg(ERR_MISISNG_ANSWER_TITLE, msg: ERR_MISSING_ANSWER_MSG)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let scoreVC = segue.destinationViewController as? ScoreVC {
            scoreVC.playerScore = self.playerScore
        }
        else if let cheatVC = segue.destinationViewController as? AnswersVC {
            cheatVC.isCheating = true
        }
    }
    
    func constructAnswersArray(arrayOfInt: [Int]) {
        for answerPos in arrayOfInt {
            answersArray.append(Games.answersDict["\(answerPos)"]!)
        }
    }
    
    /* Delegates for UITableView.*/
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
    
}
