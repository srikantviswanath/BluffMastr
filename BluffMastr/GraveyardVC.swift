//
//  GraveyardVC.swift
//  Bluffathon
//
//  Created by Srikant Viswanath on 8/2/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class GraveyardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var GraveyardLeaderboard: UITableView!
    var dummyArr = ["Kamboji", "SuddhaSaveli", "Kadala", "Kutuhala", "Raagam", "Budankai"]
    var nicheArr = ["Kamboji", "Kutuhala", "Budankai"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GraveyardLeaderboard.delegate = self
        GraveyardLeaderboard.dataSource = self
        GameMembers.gameMembers.observeGhostPlayersAdded()
        Scores.scores.listenToLeaderboardChanges {
            self.GraveyardLeaderboard.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = GraveyardLeaderboard.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            let playerName = Array(Games.leaderboard[indexPath.row].keys)[0]
            let playerScore = Array(Games.leaderboard[indexPath.row].values)[0]
            cell.configureCell(playerName, score: "\(playerScore)")
            if GameMembers.votedoutPlayers.contains(playerName){
                cell.VoteImg.image = UIImage(named: "ghost")
            }
            return cell
        } else {
            return CustomTableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Games.leaderboard.count
    }
}
