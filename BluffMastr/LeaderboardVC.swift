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
    
    var thisRoundScores = [Dictionary<String, Int>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoresCollectionView.delegate = self
        scoresCollectionView.dataSource = self
        
        thisRoundScores.append(["Kannamba": 9])
        thisRoundScores.append(["Kanchanamaala": 1])
        thisRoundScores.append(["Shakuntala": 3])
        thisRoundScores.append(["Shanmukha": 6])
        thisRoundScores.append(["kaanthamma": 4])
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thisRoundScores.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = scoresCollectionView.dequeueReusableCellWithReuseIdentifier(THIS_ROUND_CELL, forIndexPath: indexPath) as? ThisRoundCell{
            cell.configureCell(thisRoundScores[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
}
