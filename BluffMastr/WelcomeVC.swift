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

class WelcomeVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var screenNameTxtField: UITextField!
    @IBOutlet weak var instructionLbl: UILabel!
    
    var delegate: WelcomeVCDelegate?
    var parentBlurView: UIVisualEffectView!
    var firstTime: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(SCREEN_NAME) as? String {
            instructionLbl.text = STATUS_CHANGE_SCREENNAME
            firstTime = false
        } else {
            instructionLbl.text = STATUS_ENTER_SCREENNAME
            firstTime = true
        }
        self.hideKeyboardWhenTappedAround()
        self.dismissKeyboard()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(WelcomeVC.handleSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        self.view.addGestureRecognizer(singleTap)
    }
    
    @IBAction func submitScreenName(sender: UIButton) {
        if let screenName = screenNameTxtField.text where screenName != "" {
            Users.myScreenName = screenName.trim()
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(screenName.trim(), forKey: SCREEN_NAME)
            userDefaults.synchronize()
            self.delegate?.updateLabelInParentVC(screenName.trim())
            self.dismissViewControllerAnimated(true, completion: nil)
            self.parentBlurView.removeFromSuperview()
        } else {
            instructionLbl.text = ERR_SCREENNAME_MISSING_TITLE
            instructionLbl.textColor = UIColor.redColor()
        }
    }
    
    @IBAction func closeButtonOutlet(sender: UIButton) {
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(SCREEN_NAME) as? String {
            self.dismissViewControllerAnimated(true, completion: nil)
            parentBlurView.removeFromSuperview()
        } else {
            instructionLbl.text = ERR_SCREENNAME_MISSING_TITLE
            instructionLbl.textColor = UIColor.redColor()
        }
    }
    
    func handleSingleTap() {
        self.dismissViewControllerAnimated(true, completion: nil)
        parentBlurView.removeFromSuperview()
    }
    
    /* ==================UIGestureRecognizer delegate method ============= */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // either I'm a genius or I should never write code again.
        if let temp = touch.view where (temp.isKindOfClass(MaterialView) || firstTime) {
            return false
        }
        return true
    }
}
