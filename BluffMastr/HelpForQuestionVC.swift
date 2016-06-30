//
//  HelpForQuestionVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 6/29/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class HelpForQuestionVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rulesLbl: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        titleLbl.text = HELP_QUESTIONVC_TITLE
        rulesLbl.text = HELP_QUESTIONVC_BODY
        dismissBtn.setTitle("X", forState: .Normal)
    }

}
