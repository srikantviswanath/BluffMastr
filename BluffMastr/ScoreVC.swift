//
//  ScoreVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/15/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {

    var scoreAnimEngine: AnimationEngine!
    
    @IBOutlet weak var ScoreLblCenterXConstr: NSLayoutConstraint!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var scoreDescription: UILabel!
    
    var playerScore: Int!
    var updateLeaderboard = false
    var busyModalFrame = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreAnimEngine = AnimationEngine(constraints: [ScoreLblCenterXConstr])
        self.scoreLbl.text = "\(playerScore)"
        self.scoreDescription.text = "\(getScorePhrase(playerScore)) You scored:"
        busyModalFrame = showBusyModal(BUSY_SAVING_SCORE)
        Scores.scores.uploadPlayerScore(playerScore) {
            Scores.scores.accumulatePlayerScore(self.playerScore) {
                self.updateLeaderboard = true
                self.busyModalFrame.removeFromSuperview()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        playAudio(AUDIO_SHOW_SCORE)
        scoreAnimEngine.animateOnScreen(20, delay: 0.4, completed: {})
    }

    @IBAction func ShowLeaderboard(sender: UIButton!) {
        if updateLeaderboard {
            performSegueWithIdentifier(SEGUE_SHOW_LEADERBOARD, sender: nil)
        } else {
            AlertHandler.alert.showAlertMsg("Saving..", msg: "Trying to save to server")
        }
    }
}
