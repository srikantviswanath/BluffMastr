//
//  VoteResultVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/25/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class VoteResultVC: UIViewController {

    @IBOutlet weak var ResultStatusLbl: UILabel!
    @IBOutlet weak var waitingForAllVotesSpinner: UIActivityIndicatorView!
    @IBOutlet weak var ParentView: UIView!
    @IBOutlet weak var voteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voteBtn.hidden = true
        displayVoteoutResult()
    }
    
    @IBAction func revote(sender: UIButton) {
        Games.votesCastedForThisRound = Dictionary<String, String>()
        Votes.votes.resetPlayerVote()
        self.performSegueWithIdentifier(SEGUE_REVOTE, sender: nil)
        
    }
    
    func displayVoteoutResult() {
        Votes.votes.listenForVotesCasted {
            if Games.votesCastedForThisRound.count == GameMembers.playersInGameRoom.count { //everybody has voted
                self.ResultStatusLbl.textColor = UIColor.whiteColor()
                self.waitingForAllVotesSpinner.stopAnimating()
                self.ParentView.backgroundColor = UIColor(netHex: COLOR_THEME)
                if evaluateVotes() != CODE_TIE { //if its a tie, go for a revote
                    self.ResultStatusLbl.text = "\(evaluateVotes()) \(STATUS_VOTE_RESULT_PLACEHOLDER)"
                } else {
                    self.voteBtn.hidden = false
                    self.ResultStatusLbl.text = STATUS_TIE
                }
            } else {
                self.waitingForAllVotesSpinner.startAnimating()
            }
        }

    }
}
