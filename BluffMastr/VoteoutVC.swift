//
//  VoteoutVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/22/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class VoteoutVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var voteoutCollectionView: UICollectionView!
    
    var markedCellIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voteoutCollectionView.delegate = self
        voteoutCollectionView.dataSource = self
    }
    
    @IBAction func submitVoteBtnClicked(sender: UIButton!) {
        if markedCellIndexPath != nil {
            let votedAgainstDict = Games.leaderboard[(markedCellIndexPath?.row)!]
            let votedAgainstPlayer = Array(votedAgainstDict.keys)[0]
            if votedAgainstPlayer != Users.myScreenName {
                Votes.votes.submitVote(votedAgainstPlayer)
            } else {
                ErrorHandler.errorHandler.showErrorMsg(ERR_SELF_VOTE_TITLE, msg: ERR_SELF_VOTE_MSG)
            }
        } else {
            ErrorHandler.errorHandler.showErrorMsg(ERR_VOTE_ABSENT_TITLE, msg: ERR_VOTE_ABSENT_MSG)
        }
    }
    
    /* UICollectionView delegate methods */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Games.leaderboard.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = voteoutCollectionView.dequeueReusableCellWithReuseIdentifier(THIS_ROUND_CELL, forIndexPath: indexPath) as? ThisRoundCell {
            cell.configureCell(Games.leaderboard[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if markedCellIndexPath != nil {
            if let prevMarkedCell = voteoutCollectionView.cellForItemAtIndexPath(markedCellIndexPath!) as? ThisRoundCell {
                prevMarkedCell.VoteImg.image = UIImage()
                prevMarkedCell.alpha = 1.0
            }
        }
        if let selectedCell = voteoutCollectionView.cellForItemAtIndexPath(indexPath) as? ThisRoundCell {
            selectedCell.alpha = 0.8
            selectedCell.VoteImg.image = UIImage(named: "voteout")
            markedCellIndexPath = indexPath
        }
    }

}
