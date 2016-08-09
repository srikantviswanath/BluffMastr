//
//  VerdictVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 7/14/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import pop

class VerdictVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ScoreCounter: UILabel!
    @IBOutlet weak var VerdictLbl: UILabel!
    @IBOutlet weak var VerdictImg: UIImageView!
    @IBOutlet weak var VerdictView: UIView!
    @IBOutlet weak var BonusPenaltyTable: UITableView!
    @IBOutlet weak var StartNewGameBtn: UIButton!
    
    var bonusTimer: NSTimer?
    var bonusTableDataSource = [Int]()
    var animatingRowIndex = 0
    var doneAnimationBonuses = false
    
    var busyModalFrame = UIView()

    override func viewDidLoad() {
        VerdictLbl.text = "You Win!"
        VerdictLbl.hidden = true
        super.viewDidLoad()
        BonusPenaltyTable.delegate = self
        BonusPenaltyTable.dataSource = self
        ScoreCounter.text = "\(fetchPlayerScoreFromLeaderboard(Users.myScreenName))"
        StartNewGameBtn.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bonusTimer = NSTimer.scheduledTimerWithTimeInterval(1.75, target: self, selector: "animateBonusRow", userInfo: nil, repeats: true)
    }
    
    @IBAction func startNewGameBtnClicked(sender: UIButton) {
        AlertHandler.alert.showActionSheet(ALERT_START_NEW_GAME, destructiveTitle: "Absolutely", cancelTitle: "Not Yet") {
            self.performSegueWithIdentifier(SEGUE_NEW_GAME_FROM_VERDICTVC, sender: nil)
            teardownAfterStartingGame()
            resetStaticVariablesForNewGame()
        }
    }
    
    func animateBonusRow() {
        bonusTableDataSource.insert(Users.myBonusHistory[animatingRowIndex], atIndex: 0)
        animatingRowIndex += 1
        self.BonusPenaltyTable.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
        if bonusTableDataSource.count == Users.myBonusHistory.count {
            Scores.myFinalScoreRef.setValue(Int(self.ScoreCounter.text!))
            fetchOpponentScoreAndCompare()
            bonusTimer?.invalidate()
            animatingRowIndex = 0
            bonusTimer = nil
            doneAnimationBonuses = true
        }
    }
    
    func bounceScore(uiElement: AnyObject) {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(5.0, 5.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.7, 1.7))
        scaleAnim.springBounciness = 20
        uiElement.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
    }
    
    func finalVerdictAnimation() {
        let gameWinner = Array(Games.finalScores[0].keys)[0]
        let didIWin = gameWinner == Users.myScreenName
        UIView.animateWithDuration(1, animations: {
            self.VerdictImg.image = UIImage(named: didIWin ? "winner_cup" : "runner_up_dislike")
            self.VerdictImg.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-20, 60, 50, 50)
        }){ (true) in
            self.VerdictView.backgroundColor = UIColor(netHex: didIWin ?  0x00BFA5 : COLOR_THEME)
            self.VerdictLbl.text = didIWin ? "You Win!" : "\(gameWinner) wins!"
            self.VerdictLbl.hidden = false
            self.StartNewGameBtn.hidden = false
        }
    }
    
    func fetchOpponentScoreAndCompare() {
        busyModalFrame = showBusyModal(BUSY_DECIDING_WINNER)
        Scores.scores.listenForFinalScores() {
            if Games.finalScores.count == Games.leaderboard.count {
                Scores.scores.stopListeningForFinalScores()
                self.busyModalFrame.removeFromSuperview()
                self.finalVerdictAnimation()
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonusTableDataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = BonusPenaltyTable.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            let bonus = bonusTableDataSource[indexPath.row]
            let bonusReason = BONUS_PENALTY_REASON[bonus]
            if !doneAnimationBonuses {
                if bonus == BONUS_BLUFFMASTR_SURVIVAL || bonus == BONUS_VOTED_AGAINST_BLUFFMASTR {
                    cell.MainLbl.textColor = UIColor(netHex: 0x00796B)
                    playAudio(AUDIO_BONUS)
                } else {
                    cell.MainLbl.textColor = UIColor(netHex: COLOR_THEME)
                    playAudio(AUDIO_PENALTY)
                }
                cell.configureCell("\(bonus)", score: bonusReason!)
                ScoreCounter.text = "\(Int(self.ScoreCounter.text!)! + bonus)"
                bounceScore(ScoreCounter)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
