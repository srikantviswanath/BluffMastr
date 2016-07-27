//
//  WelcomeVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 7/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

protocol WelcomeVCDelegate {
    func updateLabelInParentVC(data: String)
}

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var screenNameTxtField: UITextField!
    @IBOutlet weak var instructionLbl: UILabel!
    
    var delegate: WelcomeVCDelegate?
    var parentBlurView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("screenname") as? String {
            instructionLbl.text = STATUS_CHANGE_SCREENNAME
        } else {
            instructionLbl.text = STATUS_ENTER_SCREENNAME
        }
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
    }
    
    @IBAction func submitScreenName(sender: UIButton) {
        if let screenName = screenNameTxtField.text where screenName != "" {
            Users.myScreenName = screenName
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(screenName, forKey: "screenname")
            userDefaults.synchronize()
            delegate?.updateLabelInParentVC(screenName)
            self.dismissViewControllerAnimated(true, completion: nil)
            parentBlurView.removeFromSuperview()
        } else {
            instructionLbl.text = ERR_SCREENNAME_MISSING_TITLE
            instructionLbl.textColor = UIColor.redColor()
        }
    }
}
