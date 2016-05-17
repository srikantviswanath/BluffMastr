//
//  ScoreVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/15/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {

    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var scoreDescription: UILabel!
    
    var playerScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoreLbl.text = "\(playerScore)"
        Scores.scores.uploadPlayerScore(playerScore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
