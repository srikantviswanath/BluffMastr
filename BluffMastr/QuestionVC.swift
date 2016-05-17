//
//  QuestionVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/8/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Firebase

class QuestionVC: UIViewController {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerSubmitted: UITextField!
    
    var playerScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Questions.questions.listenForNextQuestion{
            self.questionLbl.text = Games.currentQuestionTitle
            Questions.questions.fetchAnswerList{}
            
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
        if isPlayerBluffMastr(){
           performSegueWithIdentifier(SEGUE_BLUFFMASTR_CHEAT, sender: nil)
        } else {
            ErrorHandler.errorHandler.showErrorMsg(STATUS_INNOCENT_TITLE, msg: STATUS_INNOCENT_MSG)
        }
        
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
}
