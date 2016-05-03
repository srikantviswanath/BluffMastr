//
//  StagingVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class StagingVC: UIViewController {

    var isGameCreator: Bool!
    
    @IBOutlet weak var joinerStaticLbl: UILabel!
    @IBOutlet weak var codeEnteredTxt: UITextField!
    @IBOutlet weak var creatorStaticLbl: UILabel!
    @IBOutlet weak var createdGameCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isGameCreator! {
            joinerStaticLbl.hidden = true
            codeEnteredTxt.hidden = true
        } else {
            createdGameCode.hidden = true
            creatorStaticLbl.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
}
