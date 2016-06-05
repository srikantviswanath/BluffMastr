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
    override func viewDidLoad() {
        super.viewDidLoad()
        Votes.votes.listenForVotesCasted {
            if Games.votesCastedForThisRound.count == GameMembers.playersInGameRoom.count {
                self.ParentView.backgroundColor = UIColor(netHex: COLOR_THEME)
                //self.ResultStatusLbl.text =
                self.ResultStatusLbl.textColor = UIColor.whiteColor()
            } else {
                self.waitingForAllVotesSpinner.startAnimating()
            }
        }
        
        
    }
}
