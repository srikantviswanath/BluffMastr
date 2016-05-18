//
//  LeaderboardVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/17/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class LeaderboardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var scoresCollectionView: UICollectionView!
    
    var readyToshowCurrentRoundScores = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoresCollectionView.delegate = self
        scoresCollectionView.dataSource = self
        displayCurrentRoundScores()
        
    }
    
    func displayCurrentRoundScores() {
        Scores.scores.listenForPlayersSubmissions {
            if Games.playersSubmissions.count == GameMembers.playersInGameRoom.count {
                self.readyToshowCurrentRoundScores = true
                self.scoresCollectionView.reloadData()
            } else {
                self.readyToshowCurrentRoundScores = false
            }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Games.playersSubmissions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if readyToshowCurrentRoundScores {
            if let cell = scoresCollectionView.dequeueReusableCellWithReuseIdentifier(THIS_ROUND_CELL, forIndexPath: indexPath) as? ThisRoundCell{
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
    
}
