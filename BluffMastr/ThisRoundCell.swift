//
//  ThisRoundCell.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/17/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ThisRoundCell: UICollectionViewCell {
    
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var Score: UILabel!
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
    
    func configureCell(playerScoreDict: Dictionary<String, Int>) {
        self.PlayerName.text = Array(playerScoreDict.keys)[0]
        self.Score.text = "\(Array(playerScoreDict.values)[0])"
    }
}
