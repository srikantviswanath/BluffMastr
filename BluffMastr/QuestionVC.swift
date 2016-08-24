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
    @IBOutlet weak var identityBtn: UIButton!
    
    static var questionVC = QuestionVC()
    
    var playerScore: Int!
    var answersArray: [String] = [String]()
    let identityBtnRect = CGRect(origin: CGPointMake((UIScreen.mainScreen().bounds.width/2)-15, UIScreen.mainScreen().bounds.height - 38), size: CGSize(width: 30.0, height: 30.0))
    //var popUpBundle = [PopUpBubble(tipContent: TIP_GAME_PHILOSOPHY, anchorPointRect: QuestionVC().questionLbl.frame)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AlertHandler.alert.showPopUpBubble(popUpBundle[0], parentVC: self)
        answersTable.dataSource = self
        answersTable.delegate = self
        Questions.questions.listenForNextQuestion{
            self.roundLbl.text = "Round: \(Games.roundNumber)"
            self.questionLbl.text = Games.currentQuestionTitle
            Questions.questions.fetchAnswerList{
                ( isPlayerBluffMastr() ? self.constructAnswersArray([Int](1...10)) : self.constructAnswersArray(shuffleArray([Int](1...10))))
                self.answersTable.reloadData()
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.alertIfPlayerIsBluffMstr()
    }
    
    @IBAction func exitGameBtnClicked(sender: AnyObject) {
        AlertHandler.alert.showActionSheet(ALERT_LEAVE_GAME_TITLE2, destructiveTitle: "Yes", cancelTitle: "No") {
            teardownAfterStartingGame()
            resetStaticVariablesForNewGame()
            self.performSegueWithIdentifier(SEGUE_HOME_GAME, sender: nil)
        }
    }
    
    @IBAction func identityBtnClicked(sender: UIButton) {
        alertIfPlayerIsBluffMstr()
    }
    
    @IBAction func dismissHelp(segue: UIStoryboardSegue) {} //for unwinding the help modal
    
    func alertIfPlayerIsBluffMstr() {
        if isPlayerBluffMastr() {
            AlertHandler.alert.showPopUpBubble(PopUpBubble(tipContent: STATUS_BLUFFMATR_MSG, anchorPointRect: identityBtnRect, anchorDirection: .Any), parentVC: self)
        } else {
            AlertHandler.alert.showPopUpBubble(PopUpBubble(tipContent: STATUS_INNOCENT_MSG, anchorPointRect: identityBtnRect, anchorDirection: .Any), parentVC: self)
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
    
    //MARK: UIPopoverPresentationControllerDelegate methods
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
