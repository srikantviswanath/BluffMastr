//
//  ScoreVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/15/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {

    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var scoreDescription: UILabel!
    
    var playerScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoreLbl.text = "\(playerScore)"
        Scores.scores.uploadPlayerScore(playerScore)
    }

    @IBAction func revealAnswers(sender: UIButton!) {
        performSegueWithIdentifier(SEGUE_REVEAL_ANSWERS, sender: nil)
    }
    
    @IBAction func unwindFromAnswers(segue: UIStoryboardSegue){}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? AnswersVC {
            destVC.isCheating = false
        }
    }
}
