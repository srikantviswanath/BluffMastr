//
//  AlertVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 6/30/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    @IBOutlet weak var AlertTitle: UILabel!
    @IBOutlet weak var AlertMsg: UILabel!
    @IBOutlet weak var ActionBtn: UIButton!
    
    @IBAction func ActionBtnPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
