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
    @IBOutlet weak var waitingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var ParentView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.hidden = true
        attemptToDisplayVoteResults()
    }
    
    /* nextBtn shape shifts into BTN_VOTE_AGAIN, BTN_HOME or BTN_NEXT_ROUND based on the fate of the player after voteout */
    @IBAction func nextBtnClicked(sender: UIButton) {
        switch nextBtn.currentTitle! {
        case BTN_VOTE_AGAIN:
            Games.votesCastedForThisRound = Dictionary<String, String>()
            Votes.votes.resetPlayerVote()
            self.performSegueWithIdentifier(SEGUE_REVOTE, sender: nil)
        case BTN_GRAVEYARD:
            self.performSegueWithIdentifier(SEGUE_GO_TO_GRAVEYARD, sender: nil)
        case BTN_NEXT_ROUND:
            readyForNextRound(){
                listenForNextRoundReadiness {
                    if Games.playersReadyForNextRound.count == GameMembers.playersInGameRoom.count {
                        stopListeningForPlayersReadiness()
                        self.ResultStatusLbl.text = STATUS_STARTING_NEXT_ROUND
                        self.performSegueWithIdentifier(SEGUE_START_NEXT_ROUND, sender: nil)
                    } else {
                        self.ResultStatusLbl.text = STATUS_WAITING_OTHERS_NXT_ROUND
                        self.VotedoutPlayerLbl.hidden = true
                        self.noOfVotes.hidden = true
                        self.nextBtn.hidden = true
                        self.waitingSpinner.color = UIColor.whiteColor()
                        self.waitingSpinner.startAnimating()
                    }
                }
            }
        case BTN_DECLARE_VERDICT:
            self.performSegueWithIdentifier(SEGUE_DECLARE_VERDICT, sender: nil)
        default:
            print("Hello")
        }
        
    }
    
    func attemptToDisplayVoteResults() {
        Votes.votes.listenForVotesCasted {
            if Games.votesCastedForThisRound.count == GameMembers.playersInGameRoom.count { //everybody has voted
                Votes.votes.stopListeningForPlayersVotes()
                self.nextBtn.hidden = false
                self.ResultStatusLbl.textColor = UIColor.whiteColor()
                self.waitingSpinner.stopAnimating()
                self.ParentView.backgroundColor = UIColor(netHex: COLOR_THEME)
                
                let votedoutPlayer = evaluateVotes()
                if votedoutPlayer != CODE_TIE { //if it is not a tie, display the voted out player's details and record the myPlayer's vote in his voting history
                    Users.myBonusHistory.append(evaluateBonusOrPenaltyPerRound())
                    self.displayAndRemoveVotedoutPlayer(votedoutPlayer)
                    GameMembers.votedoutPlayers.append(votedoutPlayer)
                    FDataService.fDataService.REF_GHOST_PLAYERS.child(Games.gameUID).updateChildValues([votedoutPlayer: true])
                } else { //if its a tie, go for a revote
                    self.nextBtn.setTitle(BTN_VOTE_AGAIN, forState: .Normal)
                    self.ResultStatusLbl.text = STATUS_TIE
                }
            } else {
                self.waitingSpinner.startAnimating()
            }
        }

    }
    
    func displayAndRemoveVotedoutPlayer(votedoutPlayer: String) {
        if votedoutPlayer == Users.myScreenName {
            playAudio(AUDIO_GAME_OVER)
            VotedoutPlayerLbl.text = STATUS_YOU_ARE_OUT
            ResultStatusLbl.hidden = true
            nextBtn.setTitle(BTN_GRAVEYARD, forState: .Normal)
            teardownAfterStartingGame()
        } else {
            VotedoutPlayerLbl.text = votedoutPlayer
            noOfVotes.text = "(\(countVotes()[votedoutPlayer]!) \(VOTES))"
            ResultStatusLbl.text = "\(STATUS_VOTE_RESULT_PLACEHOLDER)"
            timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.giveVerdictForVotedoutPlayer), userInfo: nil, repeats: false)
        }
    }
    
    func giveVerdictForVotedoutPlayer() {
        let votedoutPlayer = evaluateVotes()
        if votedoutPlayer == Games.bluffMastr {
            ResultStatusLbl.text = STATUS_BLUFFMASTR_FOUND
            playAudio(AUDIO_BLUFFMASTR_VOTEDOUT)
        } else {
            ResultStatusLbl.text = STATUS_INNOCENT_PLAYER
            playAudio(AUDIO_INNOCENT_VOTEDOUT)
        }
        removePlayerFromRoomCache(votedoutPlayer)
        if GameMembers.playersInGameRoom.count <= 2 {
            nextBtn.setTitle(BTN_DECLARE_VERDICT, forState: .Normal)
        } else {
            nextBtn.setTitle(BTN_NEXT_ROUND, forState: .Normal)
        }
        if votedoutPlayer == Games.bluffMastr {
            Games.bluffMastr = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case SEGUE_REVOTE:
            let destVC = segue.destinationViewController as! LeaderboardVC
            destVC.readyToshowCurrentRoundScores = true
            destVC.revoteModeEnabled = true
            destVC.animatingLeaderboard = Games.leaderboard
        case SEGUE_GO_TO_GRAVEYARD:
            GameMembers.votedoutPlayers = [String]()
        default:
            print("How do the ghutles handle this?")
        }
    }
}
