//
//  VerdictVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 7/14/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import pop

class VerdictVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ScoreCounter: UILabel!
    @IBOutlet weak var VerdictLbl: UILabel!
    @IBOutlet weak var VerdictImg: UIImageView!
    @IBOutlet weak var VerdictView: UIView!
    @IBOutlet weak var BonusPenaltyTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        BonusPenaltyTable.delegate = self
        BonusPenaltyTable.dataSource = self
        ScoreCounter.text = "\(fetchPlayerScoreFromLeaderboard(Users.myScreenName))"
    }
    
    func bounceScore(uiElement: AnyObject) {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(5.0, 5.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.7, 1.7))
        scaleAnim.springBounciness = 20
        uiElement.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.myBonusHistory.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let customCell = cell as? CustomTableViewCell {
            self.VerdictLbl.text = "You Win"
            self.VerdictLbl.hidden = true
            cell.alpha = 0
            let delayBetweenRowInserts = 2 + Double(indexPath.row) * 2.0; //calculate delay
            UIView.animateWithDuration(2, delay: delayBetweenRowInserts, options: .TransitionCurlUp, animations: {
                let bonus = Int(customCell.MainLbl.text!)
                if bonus == BONUS_BLUFFMASTR_SURVIVAL || bonus == BONUS_VOTED_AGAINST_BLUFFMASTR {
                    customCell.MainLbl.textColor = UIColor(netHex: 0x00796B)
                    playAudio(AUDIO_BONUS)
                } else {
                    customCell.MainLbl.textColor = UIColor.redColor()
                    playAudio(AUDIO_PENALTY)
                }
                cell.alpha = 1.0
                }, completion: { (true) in
                    self.ScoreCounter.text = "\(Int(self.ScoreCounter.text!)! + Users.myBonusHistory[indexPath.row])"
                    self.bounceScore(self.ScoreCounter)
                    if indexPath.row == Users.myBonusHistory.count - 1 {
                        UIView.animateWithDuration(1, animations: {
                            self.VerdictImg.image = UIImage(named: "winner_cup")
                            self.VerdictImg.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-20, 60, 50, 50)
                        }){ (true) in
                            self.VerdictView.backgroundColor = UIColor(netHex: 0x00BFA5)
                            self.VerdictLbl.hidden = false
                        }
                    }
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = BonusPenaltyTable.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            let bonus = Users.myBonusHistory[indexPath.row]
            let bonusReason = BONUS_PENALTY_REASON[bonus]
            cell.configureCell("\(bonus)", score: bonusReason!)
            if bonus == BONUS_VOTED_AGAINST_BLUFFMASTR || bonus == BONUS_BLUFFMASTR_SURVIVAL{
                
            } else {
                
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
