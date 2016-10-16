//
//  PopUpTutorialVC.swift
//  Bluffathon
//
//  Created by Srikant Viswanath on 8/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class PopUpTutorialVC: UIViewController {
    
    @IBOutlet weak var ActionBtn: UIButton!
    @IBOutlet weak var tutorialTip: UILabel!
    
    @IBAction func ActionBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        parentVC.view.alpha = 1.0
    }
    
    var parentSourceDelegate: PopUpTutorialDelegate!
    var popUpBubbleIndex = 0
    var parentVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
}

protocol PopUpTutorialDelegate {
    func displayPopup()
}
