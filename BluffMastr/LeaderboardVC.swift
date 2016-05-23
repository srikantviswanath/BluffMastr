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
    
    var readyToshowCurrentRoundScores = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScoresCollectionView.delegate = self
        currentScoresCollectionView.dataSource = self
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        displayCurrentRoundScores()
    }
    
    @IBAction func voteoutBtnClicked(sender: UIButton!) {
        performSegueWithIdentifier(SEGUE_TO_VOTEOUT, sender: nil)
    }
    
    func displayCurrentRoundScores() {
        Scores.scores.listenForPlayersSubmissions {
            if Games.playersSubmissions.count == GameMembers.playersInGameRoom.count {
                self.readyToshowCurrentRoundScores = true
                Scores.scores.fetchLeaderboard {
                    self.leaderboardTableView.reloadData()
                }
                self.thisRoundStatus.text = STATUS_LAST_ROUND_SCORES
                self.currentScoresCollectionView.reloadData()
            } else {
                self.readyToshowCurrentRoundScores = false
                self.thisRoundStatus.text = STATUS_WAITING_ALL_ANSWERS
            }
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
        if readyToshowCurrentRoundScores {
            if let cell = currentScoresCollectionView.dequeueReusableCellWithReuseIdentifier(THIS_ROUND_CELL, forIndexPath: indexPath) as? ThisRoundCell{
                cell.configureCell(Games.playersSubmissions[indexPath.row])
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            ErrorHandler.errorHandler.showErrorMsg("Waitin for other players", msg: "Burrio")
            return UICollectionViewCell()
        }
    }
    
    /* UITableView delegate methods - To display current leaderboard standings*/
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Games.leaderboard.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if readyToshowCurrentRoundScores {
            if let cell = leaderboardTableView.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
                let playerName = Array(Games.leaderboard[indexPath.row].keys)[0]
                let playerScore = Array(Games.leaderboard[indexPath.row].values)[0]
                cell.configureCell(playerName, score: "\(playerScore)")
                return cell
            } else {
                return UITableViewCell()
            }
            
        } else {
            return UITableViewCell()
        }
    }
    
    
}
