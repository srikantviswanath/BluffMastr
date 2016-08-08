//
//  GraveyardVC.swift
//  Bluffathon
//
//  Created by Srikant Viswanath on 8/2/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Firebase

class GraveyardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var GraveyardLeaderboard: UITableView!
    var dummyArr = ["Kamboji", "SuddhaSaveli", "Kadala", "Kutuhala", "Raagam", "Budankai"]
    var nicheArr = ["Kamboji", "Kutuhala", "Budankai"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GraveyardLeaderboard.delegate = self
        GraveyardLeaderboard.dataSource = self
        GameMembers.gameMembers.observeGhostPlayersAdded {
            dispatch_async(dispatch_get_main_queue(), {
                playAudio("female_scream", fileType: "mp3")
                self.GraveyardLeaderboard.reloadData()
            })
            if (GameMembers.originalPlayersAtGameStart.count - GameMembers.votedoutPlayers.count <= 2) {
                self.performSegueWithIdentifier(SEGUE_VERDICT_FOR_GHOST, sender: nil)
            }
        }
        
        Scores.scores.listenToLeaderboardChanges {
            dispatch_async(dispatch_get_main_queue(), { 
                playAudio("spooky_breath")
                self.GraveyardLeaderboard.reloadData()
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = GraveyardLeaderboard.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            let playerName = Array(Games.leaderboard[indexPath.row].keys)[0]
            let playerScore = Array(Games.leaderboard[indexPath.row].values)[0]
            cell.configureGraveyardCell(playerName, score: "\(playerScore)")
            return cell
        } else {
            return CustomTableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Games.leaderboard.count
    }
}
