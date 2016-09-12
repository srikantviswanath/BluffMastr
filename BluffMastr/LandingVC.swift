//
//  ViewController.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import pop

class LandingVC: UIViewController, WelcomeVCDelegate {

    
    var createJoinAnimEngine: AnimationEngine!
    var userProfileAnimEngine: AnimationEngine!
    @IBOutlet weak var CreateJoinTrailingConstr: NSLayoutConstraint!
    @IBOutlet weak var CreateJoinLeadingConstr: NSLayoutConstraint!
    
    @IBOutlet weak var createGameBtn: UIButton!
    @IBOutlet weak var joinGameBtn: UIButton!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var ProfileView: MaterialView!
    @IBOutlet weak var InGameTutorialSwitch: UISwitch!
    
    var timer = NSTimer()
    
    var isGameCreator = true
    var gameCreationActivityIndicator = UIActivityIndicatorView()
    var busyModalFrame = UIView()
    var popUpTutorialBundle: [PopUpBubble] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTutorialSwitchState()
        Questions.questions.fetchMaxNumberOfQuestions {}
        createJoinAnimEngine = AnimationEngine(leadingConstraint: CreateJoinLeadingConstr, trailingConstraint: CreateJoinTrailingConstr)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        createGameBtn.enabled = false
        joinGameBtn.enabled = false
        createJoinAnimEngine.animateOnScreen(17) {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                if let screenNameFromDefaults = NSUserDefaults.standardUserDefaults().objectForKey("screenname") as? String {
                    self.screenNameLabel.text = screenNameFromDefaults
                    Users.myScreenName = screenNameFromDefaults
                } else {
                    AlertHandler.alert.showWelcomeModal(self)
                }
                UIView.animateWithDuration(0.2, animations: {self.ProfileView.alpha = 1}, completion: {
                    (true) in
                    self.createGameBtn.enabled = true
                    self.joinGameBtn.enabled = true
                })
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if InGameTutorialSwitch.on {
            EnableInGameTutorial = true
        } else {
            EnableInGameTutorial = false
        }
    }
    
    func initTutorialSwitchState() {
        if EnableInGameTutorial {
            InGameTutorialSwitch.setOn(true, animated: true)
        } else {
            InGameTutorialSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func createGame(sender: UIButton!){
        view.endEditing(true)
        isGameCreator = true
        Games.gameCreator = Users.myScreenName
        GameMembers.playersInGameRoom = []
        Users.users.createAnonymousUser(Users.myScreenName)
        busyModalFrame = showBusyModal(BUSY_CREATING_GAME)
        Games.games.createGame(Users.myScreenName) {
            Scores.scores.setScoreRefs()
            self.busyModalFrame.removeFromSuperview()
            self.performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
        }
    }
    
    @IBAction func joinGame(sender: UIButton!){
        isGameCreator = false
        GameMembers.playersInGameRoom = []
        Users.users.createAnonymousUser(Users.myScreenName)
        performSegueWithIdentifier(SEGUE_CREATE_JOIN_GAME, sender: nil)
    }
    
    @IBAction func changeName(sender: UIButton) {
        AlertHandler.alert.showWelcomeModal(self)
    }
    
    @IBAction func changeScreenName(sender: AnyObject) {
        AlertHandler.alert.showWelcomeModal(self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_CREATE_JOIN_GAME {
            let destVC = segue.destinationViewController as! StagingVC
            destVC.isGameCreator = isGameCreator
        }
    }
    
    /* ==================UITextField delegate methods ============= */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* ==================WelcomeVC delegate method ============= */
    func updateLabelInParentVC(data: String) {
        self.screenNameLabel.text = data
    }
    
    
    //MARK: PopUpTutorial Delegate Method
    func displayPopup() {
    }
}

