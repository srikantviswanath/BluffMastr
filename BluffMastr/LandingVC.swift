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
            performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
        } else {
            showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG )
        }
        
    }
    
    @IBAction func joinGame(sender: UIButton!){
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = false
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
        }
    }

}

