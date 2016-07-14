//
//  WelcomeVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 7/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var screenNameTxtField: UITextField!
    @IBOutlet weak var instructionLbl: UILabel!
    
    var parentBlurView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitScreenName(sender: UIButton) {
        if let screenName = screenNameTxtField.text where screenName != "" {
            Users.myScreenName = screenName
            self.dismissViewControllerAnimated(true, completion: nil)
            parentBlurView.removeFromSuperview()
        } else {
            instructionLbl.text = ERR_SCREENNAME_MISSING_TITLE
            instructionLbl.textColor = UIColor.redColor()
        }
    }
}
