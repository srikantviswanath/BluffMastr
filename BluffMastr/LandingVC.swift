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
    
    func showErrorMsg(title: String!, msg: String!){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func createGame(sender: UIButton!){
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = true
            
            //Create anonymous session for the screenname.
            FDataService.fDataService.REF_BASE.authAnonymouslyWithCompletionBlock { error, authData in
                if error != nil {
                    NSLog("There was an error logging in anonymously")
                } else {
                    // User successfully authenticated anonymously...
                    
                    let newUser = [
                        "provider": authData.provider,
                        "screenName": screenName
                    ]
                    
                    FDataService.fDataService.createNewUser(authData, userDict: newUser)
                }
            }
            newGameDict = FDataService.fDataService.createGame(screenName)
            
            performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
        } else {
            showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG )
        }
        
    }
    
    @IBAction func joinGame(sender: UIButton!){
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = false
            
            //Create anonymous session for the screenname.
            FDataService.fDataService.REF_BASE.authAnonymouslyWithCompletionBlock { error, authData in
                if error != nil {
                    NSLog("There was an error logging in anonymously")
                } else {
                    // User successfully authenticated anonymously...
                    
                    let newUser = [
                        "provider": authData.provider,
                        "screenName": screenName
                    ]
                    
                    FDataService.fDataService.createNewUser(authData, userDict: newUser)
                }
            }
            
            performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
        } else {
            showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_CREATE_JOIN_GAME {
            let destVC = segue.destinationViewController as! StagingVC
            destVC.isGameCreator = isGameCreator
            destVC.screenTitle = screenNameTxt.text
            destVC.newGameInfoDict = newGameDict
        }
    }

}

