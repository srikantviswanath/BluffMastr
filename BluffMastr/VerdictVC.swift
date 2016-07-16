//
//  VerdictVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 7/14/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class VerdictVC: UIViewController {
    
    @IBOutlet weak var ScoreCounter: UILabel!
    @IBOutlet weak var VerdictLbl: UILabel!
    @IBOutlet weak var VerdictImg: UIImageView!
    @IBOutlet weak var VerdictView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreCounter.text = "10" //TODO: Fetch from Games.leaderboard
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1, animations: {
            self.ScoreCounter.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), 132)
        }) {(true) in
                self.VerdictView.backgroundColor = UIColor(netHex: 0x009688)
                self.VerdictImg.image = UIImage(named: "winner_cup")
                self.VerdictImg.frame = CGRectMake(self.VerdictImg.center.x, self.VerdictImg.center.y, 60, 60)
            }
    }

}
