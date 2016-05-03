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
    @IBOutlet weak var joinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isGameCreator! {
            joinerStaticLbl.hidden = true
            codeEnteredTxt.hidden = true
            joinBtn.hidden = true
        } else {
            createdGameCode.hidden = true
            creatorStaticLbl.hidden = true
        }
    }
    
    //TODO-> This code is being repeated. Solution?
    func showErrorMsg(title: String!, msg: String!){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func joinGame(sender: UIButton!){
        if let gameCode = codeEnteredTxt.text where gameCode != "" {
            //validate code and enter this playe rin the game room
        } else {
            showErrorMsg(ERR_GAMECODE_MISSING_TITLE, msg: ERR_GAMECODE_MISSING_MSG)
        }
    }
    
}
