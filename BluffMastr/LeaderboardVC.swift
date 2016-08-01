//
//  LeaderboardVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/17/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class LeaderboardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var currentScoresCollectionView: UICollectionView!
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var thisRoundStatus: UILabel!
    @IBOutlet weak var leaderboardStatus: UILabel!
    @IBOutlet weak var VoteoutBtn: UIButton!
    @IBOutlet weak var VCTitle: UILabel!
    
    
    var readyToshowCurrentRoundScores: Bool?
    var markedCellIndexPath: NSIndexPath?
    var voteoutModeEnabled: Bool = false
    var revoteModeEnabled: Bool = false
    var animatingLeaderboard = [Dictionary<String, Int>]()
    var revSortedleaderboard = [Dictionary<String, Int>]()
    var leaderBoardTimer: NSTimer?
    var animatingRowIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScoresCollectionView.delegate = self
        currentScoresCollectionView.dataSource = self
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        
        VoteoutBtn.hidden = true
        
        if !revoteModeEnabled {
            displayCurrentRoundScores()
        } else {
            VoteoutBtn.hidden = false
            voteoutModeEnabled = true
            self.thisRoundStatus.text = STATUS_LAST_ROUND_SCORES
            leaderboardStatus.text = STATUS_START_VOTING
            VCTitle.text = "\(Array(animatingLeaderboard.first!.keys)[0]) is leading"
        }
    }
    
    func startAnimatingLeaderboard() {
        animatingLeaderboard.insert(revSortedleaderboard[animatingRowIndex], atIndex: 0)
        animatingRowIndex += 1
        leaderboardTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Right)
        if animatingLeaderboard.count == Games.leaderboard.count {
            leaderBoardTimer?.invalidate()
            animatingRowIndex = 0
            resetReadiness()
            AlertHandler.alert.showAlertMsg(ALERT_BEGIN_VOTING_TITLE, msg: ALERT_BEGIN_VOTING_MSG)
            leaderboardStatus.text = STATUS_START_VOTING
            VoteoutBtn.hidden = false
            voteoutModeEnabled = true
            let leadingScorer = Array(Games.leaderboard.first!.keys)[0]
            VCTitle.text = "\(leadingScorer) is leading"
        }
    }
    
    @IBAction func voteoutBtnClicked(sender: UIButton!) {
        validateVoteAndSubmit()
    }
    
    @IBAction func answersBtnClicked(sender: UIButton) {
        performSegueWithIdentifier(SEGUE_REVEAL_ANSWERS, sender: nil)
    }
    @IBAction func unwindFromAnswers(segue: UIStoryboardSegue) {}
    
    func displayCurrentRoundScores() {
        Scores.scores.listenForPlayersSubmissions {
            if Games.playersSubmissions.count == GameMembers.playersInGameRoom.count {
                Scores.scores.stopListeningForPlayerScores()
                self.readyToshowCurrentRoundScores = true
                Scores.scores.fetchLeaderboard {
                    self.revSortedleaderboard = Games.leaderboard.reverse()
                    self.leaderBoardTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LeaderboardVC.startAnimatingLeaderboard), userInfo: nil, repeats: true)
                }
                self.thisRoundStatus.text = STATUS_LAST_ROUND_SCORES
                self.currentScoresCollectionView.reloadData()
            } else {
                self.readyToshowCurrentRoundScores = false
                self.thisRoundStatus.text = STATUS_WAITING_ALL_ANSWERS
            }
        }
    }
    
    func validateVoteAndSubmit() {
        if markedCellIndexPath != nil {
            let votedAgainstDict = Games.leaderboard[(markedCellIndexPath?.row)!]
            let votedAgainstPlayer = Array(votedAgainstDict.keys)[0]
            if votedAgainstPlayer != Users.myScreenName {
                Votes.votes.submitVote(votedAgainstPlayer) {
                    Users.mycurrentVote = votedAgainstPlayer
                    self.performSegueWithIdentifier(SEGUE_TO_VOTE_RESULT, sender: nil)
                }
            } else {
                AlertHandler.alert.showAlertMsg(ERR_SELF_VOTE_TITLE, msg: ERR_SELF_VOTE_MSG)
            }
        } else {
            AlertHandler.alert.showAlertMsg(ERR_VOTE_ABSENT_TITLE, msg: ERR_VOTE_ABSENT_MSG)
        }
    }
    
    /* UICollectionView delegate methods - To display scores of this round*/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Games.playersSubmissions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if readyToshowCurrentRoundScores! {
            if let cell = currentScoresCollectionView.dequeueReusableCellWithReuseIdentifier(THIS_ROUND_CELL, forIndexPath: indexPath) as? ThisRoundCell{
                cell.configureCell(Games.playersSubmissions[indexPath.row])
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            return ThisRoundCell()
        }
    }
    
    /* UITableView delegate methods - To display current leaderboard standings*/
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animatingLeaderboard.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if readyToshowCurrentRoundScores! {
            if let cell = leaderboardTableView.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
                let playerName = Array(animatingLeaderboard[indexPath.row].keys)[0]
                let playerScore = Array(animatingLeaderboard[indexPath.row].values)[0]
                cell.configureCell(playerName, score: "\(playerScore)")
                return cell
            } else {
                return UITableViewCell()
            }
            
        } else {
            return UITableViewCell()
        }
    }
        
    // Can only select one cell at a time to cast vote ONLY WHEN voteoutModeEnabled is true //
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if voteoutModeEnabled {
            if markedCellIndexPath != nil { //uncheck the previsouly selected cell
                if let prevMarkedCell = leaderboardTableView.cellForRowAtIndexPath(markedCellIndexPath!) as? CustomTableViewCell {
                    prevMarkedCell.VoteImg.image = UIImage(named: "empty_vote")
                    prevMarkedCell.alpha = 1.0
                }
            }
            if let selectedCell = leaderboardTableView.cellForRowAtIndexPath(indexPath) as? CustomTableViewCell {
                selectedCell.alpha = 0.8
                selectedCell.VoteImg.image = UIImage(named: "voteout")
                markedCellIndexPath = indexPath
                let bgColorView = UIView()
                bgColorView.backgroundColor = UIColor.clearColor()
                selectedCell.selectedBackgroundView = bgColorView
            }
        }
    }
}
