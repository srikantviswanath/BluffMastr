//
//  ViewController.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import pop

class LandingVC: UIViewController, UITextFieldDelegate {

    
    var createJoinAnimEngine: AnimationEngine!
    var screenNameAnimEngine: AnimationEngine!
    @IBOutlet weak var CreateJoinTrailingConstr: NSLayoutConstraint!
    @IBOutlet weak var CreateJoinLeadingConstr: NSLayoutConstraint!
    @IBOutlet weak var ScreenNameLeadingConstr: NSLayoutConstraint!
    @IBOutlet weak var ScreenNmeTrailingConstr: NSLayoutConstraint!
    
    @IBOutlet weak var screenNameTxt: UITextField!
    
    var isGameCreator = true
    var newGameDict: Dictionary<String, String>!
    var gameCreationActivityIndicator = UIActivityIndicatorView()
    var busyModalFrame = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createJoinAnimEngine = AnimationEngine(leadingConstraint: CreateJoinLeadingConstr, trailingConstraint: CreateJoinTrailingConstr)
        screenNameAnimEngine = AnimationEngine(leadingConstraint: ScreenNameLeadingConstr, trailingConstraint: ScreenNmeTrailingConstr)
        screenNameTxt.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(animated: Bool) {
        createJoinAnimEngine.animateOnScreen(17)
        screenNameAnimEngine.animateOnScreen(25)
    }
    
    
    @IBAction func createGame(sender: UIButton!){
        view.endEditing(true)
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = true
            Games.gameCreator = screenName
            Users.myScreenName = screenName
            GameMembers.playersInGameRoom = []
            Users.users.createAnonymousUser(screenName)
            busyModalFrame = showBusyModal(BUSY_CREATING_GAME)
            Games.games.createGame(screenName) {
                self.busyModalFrame.removeFromSuperview()
                self.performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
            }
        } else {
            AlertHandler.alert.showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG )
        }
        
    }
    
    @IBAction func joinGame(sender: UIButton!){
        if let screenName = screenNameTxt.text where screenName != "" {
            isGameCreator = false
            GameMembers.playersInGameRoom = []
            Users.users.createAnonymousUser(screenName)
            performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
        } else {
            AlertHandler.alert.showErrorMsg(ERR_SCREENNAME_MISSING_TITLE, msg: ERR_SCREENNAME_MISSIN_MSG )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_CREATE_JOIN_GAME {
            let destVC = segue.destinationViewController as! StagingVC
            destVC.isGameCreator = isGameCreator
            destVC.screenTitle = screenNameTxt.text
        }
    }
    
    /* ==================UITextField delegate methods ============= */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

