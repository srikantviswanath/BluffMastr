//
//  AlertVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 6/30/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

protocol AlertVCDelegate {
    func didPressOK(sender: UIButton)
}

class AlertVC: UIViewController {
    
    @IBOutlet weak var AlertTitle: UILabel!
    @IBOutlet weak var AlertMsg: UILabel!
    @IBOutlet weak var ActionBtn: UIButton!
    @IBOutlet weak var ContainerView : UIView!
    @IBOutlet weak var AlertBox: UIView!
    
    var parentBlurView: UIVisualEffectView!
    var delegate: AlertVCDelegate?
    var senderGlobal: UIButton! // To pass the button via delegate to StagingVC
    
    @IBAction func ActionBtnPressed(sender: UIButton) {
        senderGlobal = sender
        self.dismissViewControllerAnimated(true, completion: nil)
        parentBlurView.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Delegate should only be called after the user pressed the OK button
        // and the View is dismissed.
        delegate?.didPressOK(senderGlobal)
    }
    
}
