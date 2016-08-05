//
//  PlayerInRoomCell.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/3/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var MainLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var VoteImg : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(mainLbl: String!, score:String = ""){
        MainLbl.text = mainLbl
        if score != "" {
            scoreLbl.text = score
        }
    }
    
    func configureLeaderboardCell(playerName: String, score: String) {
        configureCell(playerName, score: score)
        if GameMembers.votedoutPlayers.contains(playerName) {
            VoteImg.image = UIImage(named: "votedout_cemetery")
            MainLbl.textColor = UIColor.lightGrayColor()
            scoreLbl.textColor = UIColor.lightGrayColor()
            self.userInteractionEnabled = false
        }
    }
    
    func configureGraveyardCell(playerName: String, score: String) {
        configureCell(playerName, score: score)
        if GameMembers.votedoutPlayers.contains(playerName){
            VoteImg.image = UIImage(named: "ghost")
        } else {
            VoteImg.image = UIImage(named: "alive")
        }
    }

}
