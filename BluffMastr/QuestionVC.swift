//
//  QuestionVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/8/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Firebase
import Instructions

class QuestionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDataSource {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    @IBOutlet weak var roundLbl: UILabel!
    @IBOutlet weak var identityBtn: UIButton!
    
    let coachController = CoachMarksController()
    
    var playerScore: Int!
    var answersArray: [String] = [String]()
    let identityBtnRect = CGRect(origin: CGPointMake((UIScreen.mainScreen().bounds.width/2)-15, UIScreen.mainScreen().bounds.height - 38), size: CGSize(width: 30.0, height: 30.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coachController.dataSource = self
        coachController.overlay.blurEffectStyle = .Dark
        self.coachController.overlay.allowTap = true
        
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
        super.viewDidAppear(animated)
        if EnableInGameTutorial {
            coachController.startOn(self)
        }
        //self.alertIfPlayerIsBluffMstr()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        coachController.stop(immediately: true)
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
    
    //MARK: CoachMarksControllerDataSource delegate methods
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachController.helper.coachMarkForView(questionLbl)
        case 1:
            var answersCoachMark = coachController.helper.coachMarkForView(answersTable)
            answersCoachMark.arrowOrientation = .Bottom
            return answersCoachMark
        case 2:
            return coachController.helper.coachMarkForView(identityBtn)
        default:
            return coachController.helper.coachMarkForView()
        }
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        print("coachMarkViewsForIndex: \(index)")
        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)
        
        coachViews = coachMarksController.helper.defaultCoachViewsWithArrow(true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Each round begins with a survey question. Least common survey answer has most points and vice versa"
            coachViews.bodyView.hintLabel.textColor = UIColor(netHex: COLOR_THEME)
        case 1:
            coachViews.bodyView.hintLabel.text = "These survey answers are shown in a random order. Only the BluffMastr views them sorted by score(LOW to HIGH)"
            coachViews.bodyView.hintLabel.textColor = UIColor(netHex: COLOR_THEME)
        case 2:
            coachViews.bodyView.hintLabel.text = "Tap here to reveal your identity"
            coachViews.bodyView.hintLabel.textColor = UIColor(netHex: COLOR_THEME)

        default: break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

}
