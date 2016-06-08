//
//  ViewController.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

    @IBOutlet weak var screenNameTxt: UITextField!
    
    var isGameCreator = true
    var newGameDict: Dictionary<String, String>!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createGame(sender: UIButton!){
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = true
            GameMembers.playersInGameRoom = []
            Users.users.createAnonymousUser(screenName)
            Games.games.createGame(screenName) {
                Users.myScreenName = screenName
                self.performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
            }
        } else {
            ErrorHandler.errorHandler.showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG )
        }
        
    }
    
    @IBAction func joinGame(sender: UIButton!){
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = false
            GameMembers.playersInGameRoom = []
            Users.users.createAnonymousUser(screenName)
            performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
        } else {
            ErrorHandler.errorHandler.showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_CREATE_JOIN_GAME {
            let destVC = segue.destinationViewController as! StagingVC
            destVC.isGameCreator = isGameCreator
            destVC.screenTitle = screenNameTxt.text
        }
    }

}

