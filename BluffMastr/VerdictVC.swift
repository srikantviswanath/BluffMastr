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
        self.VerdictLbl.text = "You Lose"
        self.VerdictLbl.hidden = true
        cell.alpha = 0
        let delayBetweenRowInserts = 2 + Double(indexPath.row) * 2.0; //calculate delay
        UIView.animateWithDuration(2, delay: delayBetweenRowInserts, options: .TransitionCurlUp, animations: {
            cell.alpha = 1.0
            }, completion: { (true) in
                self.ScoreCounter.text = "\(Int(self.ScoreCounter.text!)! + Users.myBonusHistory[indexPath.row])"
                self.bounceScore(self.ScoreCounter)
                if indexPath.row == Users.myBonusHistory.count - 1 {
                    UIView.animateWithDuration(1, animations: {
                        self.VerdictImg.image = UIImage(named: "runner_up_dislike")
                        self.VerdictImg.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-20, 60, 50, 50)
                    }){ (true) in
                        self.VerdictView.backgroundColor = UIColor(netHex: 0xF44336)
                        self.VerdictLbl.hidden = false
                    }
                }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = BonusPenaltyTable.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
        cell.configureCell("\(Users.myBonusHistory[indexPath.row])")
        return cell
            
        } else {
            return UITableViewCell()
        }
    }

}
