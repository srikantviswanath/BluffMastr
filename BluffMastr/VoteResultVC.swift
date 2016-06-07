//
//  VoteResultVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/25/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class VoteResultVC: UIViewController {

    @IBOutlet weak var VotedoutPlayerLbl: UILabel!
    @IBOutlet weak var noOfVotes: UILabel!
    @IBOutlet weak var ResultStatusLbl: UILabel!
    @IBOutlet weak var waitingForAllVotesSpinner: UIActivityIndicatorView!
    @IBOutlet weak var ParentView: UIView!
    @IBOutlet weak var voteBtn: UIButton!
    
    var timer = NSTimer()
    
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
                if evaluateVotes() != CODE_TIE { //if it is not a tie, display the voted out player's details
                    self.displayVotedoutPlayer()
                } else { //if its a tie, go for a revote
                    self.voteBtn.hidden = false
                    self.ResultStatusLbl.text = STATUS_TIE
                }
            } else {
                self.waitingForAllVotesSpinner.startAnimating()
            }
        }

    }
    
    func displayVotedoutPlayer() {
        self.VotedoutPlayerLbl.text = evaluateVotes()
        self.noOfVotes.text = "\(countVotes()[evaluateVotes()]!) \(VOTES)"
        self.ResultStatusLbl.text = "\(STATUS_VOTE_RESULT_PLACEHOLDER)"
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.giveVerdictForVotedoutPlayer), userInfo: nil, repeats: false)
    }
    
    func giveVerdictForVotedoutPlayer() {
        if evaluateVotes() == Games.bluffMastr {
            ResultStatusLbl.text = STATUS_BLUFFMASTR_FOUND
        } else {
            ResultStatusLbl.text = STATUS_INNOCENT_PLAYER
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? LeaderboardVC {
            destVC.readyToshowCurrentRoundScores = true
        }
    }
}
