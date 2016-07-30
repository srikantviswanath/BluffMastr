//
//  ConclusionVC.swift
//  Bluffathon
//
//  Created by Nitin Jami on 7/29/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ConclusionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func letsGoOutlet(sender: UIButton) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(true, forKey: IS_TUTORIAL_SHOWN)
        userDefaults.synchronize()
    }
    
}
