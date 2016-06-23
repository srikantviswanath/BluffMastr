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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreAnimEngine = AnimationEngine(constraints: [ScoreLblCenterXConstr])
        self.scoreLbl.text = "\(playerScore)"
        self.scoreDescription.text = "\(getScorePhrase(playerScore)) You scored:"
        Scores.scores.uploadPlayerScore(playerScore) {
            Scores.scores.accumulatePlayerScore(self.playerScore)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //playAudio(AUDIO_SHOW_SCORE)
        scoreAnimEngine.animateOnScreen(20)
    }

    @IBAction func revealAnswers(sender: UIButton!) {
        performSegueWithIdentifier(SEGUE_REVEAL_ANSWERS, sender: nil)
    }
    
    @IBAction func unwindFromAnswers(segue: UIStoryboardSegue){}
    
    @IBAction func ShowLeaderboard(sender: UIButton!) {
        performSegueWithIdentifier(SEGUE_SHOW_LEADERBOARD, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? AnswersVC {
            destVC.isCheating = false
        }
    }
}
