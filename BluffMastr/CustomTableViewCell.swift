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
    @IBOutlet weak var TrailingLbl: UILabel!
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
    
    func configureLeaderboardCell(playerName: String, score: String, voteoutModeEnabled: Bool) {
        configureCell(playerName, score: score)
        if GameMembers.votedoutPlayers.contains(playerName) {
            VoteImg.image = UIImage(named: "votedout_cemetery")
            MainLbl.textColor = UIColor.lightGrayColor()
            scoreLbl.textColor = UIColor.lightGrayColor()
            self.userInteractionEnabled = false
        }
        if voteoutModeEnabled {
            VoteImg.image = UIImage(named: "empty_vote")
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
    
    func configureBonusCell(bonus: Int, bonusReason: String, roundInfo: String) {
        var bonusWithSign = ""
        if roundInfo != "" { TrailingLbl.text = roundInfo }
        if bonus == BONUS_BLUFFMASTR_SURVIVAL || bonus == BONUS_VOTED_AGAINST_BLUFFMASTR {
            bonusWithSign = "+\(bonus)"
            scoreLbl.textColor = UIColor(netHex: 0x00796B)
            playAudio(AUDIO_BONUS)
        } else {
            bonusWithSign = "\(bonus)"
            scoreLbl.textColor = UIColor(netHex: COLOR_THEME)
            playAudio(AUDIO_PENALTY)
        }
        configureCell(bonusReason, score: bonusWithSign)
    }

}
