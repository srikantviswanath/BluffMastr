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
        //parentVC
    }
    
    var parentSourceDelegate: PopUpTutorialDelegate!
    var popUpBubbleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
}

protocol PopUpTutorialDelegate {
    func displayPopup()
}
