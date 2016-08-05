//
//  StagingVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class StagingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AlertVCDelegate {
    
    @IBOutlet weak var barTitle: UILabel!
    @IBOutlet weak var joinerStaticLbl: UILabel!
    @IBOutlet weak var codeEnteredTxtFirst: UITextField!
    @IBOutlet weak var codeEnteredTxtSecond: UITextField!
    @IBOutlet weak var codeEnteredTxtThird: UITextField!
    @IBOutlet weak var codeEnteredTxtFourth: UITextField!
    @IBOutlet weak var creatorStaticLbl: UILabel!
    @IBOutlet weak var createdGameCode: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var playersTable: UITableView!
    
    var isGameCreator: Bool = Bool()
    var arrayOfCodes: [String] = ["", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTable.delegate = self
        playersTable.dataSource = self
        codeEnteredTxtFirst.delegate = self
        codeEnteredTxtSecond.delegate = self
        codeEnteredTxtThird.delegate = self
        codeEnteredTxtFourth.delegate = self
        switchLblsAfterViewLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        if isGameCreator {
            GameMembers.gameMembers.observeMemberAddedOrRemoved {
                self.playersTable.reloadData()
                self.switchDataDependentLbls()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //GameMembers.gameMembers.removeGameMemberListeners()
        //Games.games.removeObserverForListenToGameChanges()
        //GameMembers.gameMembers.removeObserverForGameRoom()
    }
    
    /* =======View changing funcs after create/join game and depending on #players======== */
    
    func switchLblsAfterViewLoad(){
        barTitle.text = Users.myScreenName
        if isGameCreator {
            joinerStaticLbl.hidden = true
            codeEnteredTxtFirst.hidden = true
            codeEnteredTxtSecond.hidden = true
            codeEnteredTxtThird.hidden = true
            codeEnteredTxtFourth.hidden = true
            joinBtn.hidden = true
        } else {
            createdGameCode.hidden = true
            creatorStaticLbl.hidden = true
            statusLbl.text = ""
            startBtn.hidden = true
        }
    }

    func switchDataDependentLbls(){
        if (isGameCreator) {
            if GameMembers.playersInGameRoom.count < 3 {
                self.statusLbl.text = STATUS_NEED_MORE_PLAYERS
                self.createdGameCode.text = Games.sharedToken
            } else {
                self.startBtn.enabled = true
                self.statusLbl.text = STATUS_START_GAME
            }
        }
    }
    
    func changeViewAfterJoin() {
        statusLbl.text = STATUS_WAITING_TO_START
        joinBtn.hidden = true
        codeEnteredTxtFirst.hidden = true
        codeEnteredTxtSecond.hidden = true
        codeEnteredTxtThird.hidden = true
        codeEnteredTxtFourth.hidden = true
        joinerStaticLbl.text = CMT_GAME_PREP
    }
    
    func resetEnteredGameCodes() {
        codeEnteredTxtFirst.text = ""
        arrayOfCodes[0] = ""
        codeEnteredTxtSecond.text = ""
        arrayOfCodes[1] = ""
        codeEnteredTxtThird.text = ""
        arrayOfCodes[2] = ""
        codeEnteredTxtFourth.text = ""
        arrayOfCodes[3] = ""
    }

    //MARK:- IBActions
    
    /*validate the entered code and enter this player in the game room*/
    @IBAction func joinGame(sender: UIButton!){
        self.view.endEditing(true)
        let enteredCode = arrayOfCodes.joinWithSeparator("")
        if enteredCode.characters.count == 4 {
            Games.games.joinGame(enteredCode, gameSlave: Users.myScreenName, sucessCompleted: {
                GameMembers.gameMembers.observeMemberAddedOrRemoved {
                    self.playersTable.reloadData()
                    self.changeViewAfterJoin()
                }
                GameMembers.gameMembers.gameRoomIsRemoved {
                    //self.leaveGame(nil) this is now taken care by the delegate.
                    let alertVC = AlertHandler.alert.showAlertMsg("Host Exited", msg: "Host has left the game, now quiting...")
                    alertVC.delegate = self
                }
                Games.games.listenToGameChanges(SVC_GAME_BLUFFMASTER) { // Game starts as soon as bluffMastr is set for the game
                    self.performSegueWithIdentifier(SEGUE_START_GAME, sender: nil)
                }
            }) { //failedCompleted closure block -> Incorrect code entered: Failed to join game
                AlertHandler.alert.showAlertMsg(ERR_WRONG_CODE_TITLE, msg: ERR_WRONG_CODE_MSG)
                self.resetEnteredGameCodes()
            }
        } else {
            AlertHandler.alert.showAlertMsg(ERR_GAMECODE_MISSING_TITLE, msg: ERR_GAMECODE_MISSING_MSG)
            resetEnteredGameCodes()
        }
    }
    
    @IBAction func startGame(sender: UIButton) {
        // Mark a random member as BluffMaster
        if GameMembers.playersInGameRoom.count < MIN_PLAYERS {
            AlertHandler.alert.showAlertMsg(ERR_NEED_PLAYERS_TITLE, msg: ERR_NEED_PLAYERS_MSG)
            return
        }
        Games.games.updateGameInfo(SVC_GAME_DICT, person: "", gameDict: randomizeNextRoundData()) {
            Scores.scores.resetLeaderboard()
            Games.games.invalidateTokenUponGameStart(Games.sharedToken) // [EXPERIMENTAL]:
            self.performSegueWithIdentifier(SEGUE_START_GAME, sender: nil)
        }
    }
    
    func exitGame() {
        Users.users.deleteAnonymousUser()
        if (isGameCreator) {
            Games.games.deleteGame()
            GameMembers.gameMembers.deleteRoom()
        } else if joinBtn.hidden { // if this button is hidden, then the user already joined the game.
            GameMembers.gameMembers.removePlayerFromRoom(Users.myScreenName)
        }
    }
    
    @IBAction func leaveGame(sender: UIButton!){
        if (sender.currentTitle! == "OK") {
            self.exitGame()
            self.performSegueWithIdentifier(SEGUE_LEAVE_GAME, sender: nil)
        } else {
            AlertHandler.alert.showActionSheet(ALERT_LEAVE_GAME_TITLE, destructiveTitle: "Yes", cancelTitle: "No") {
                self.exitGame()
                self.performSegueWithIdentifier(SEGUE_LEAVE_GAME, sender: nil)
            }
        }
    }
    
    //MARK:- UITableView delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameMembers.playersInGameRoom.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = playersTable.dequeueReusableCellWithIdentifier(CUSTOM_CELL) as? CustomTableViewCell {
            cell.configureCell(GameMembers.playersInGameRoom[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    /* ==================UITextField delegate methods ============= */
    // TODO: check this version: http://stackoverflow.com/a/35232074/5915969
    // Used Version: http://stackoverflow.com/a/21715408/5915969
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let length = (textField.text?.characters.count)! + string.characters.count - range.length
        if length == 1 {
            switch textField {
            case codeEnteredTxtFirst:
                self.performSelector(#selector(StagingVC.setNextResponder(_:)), withObject: codeEnteredTxtSecond, afterDelay: 0.0)
            case codeEnteredTxtSecond:
                self.performSelector(#selector(StagingVC.setNextResponder(_:)), withObject: codeEnteredTxtThird, afterDelay: 0.0)
            case codeEnteredTxtThird:
                self.performSelector(#selector(StagingVC.setNextResponder(_:)), withObject: codeEnteredTxtFourth, afterDelay: 0.0)
            case codeEnteredTxtFourth:
                self.performSelector(#selector(UIViewController.dismissKeyboard), withObject: nil, afterDelay: 0.0)
            default: break
            }
        } else if textField.text?.characters.count == 1 && length == 0 {
            switch textField {
            case codeEnteredTxtFourth:
                self.performSelector(#selector(StagingVC.setNextResponder(_:)), withObject: codeEnteredTxtThird, afterDelay: 0.0)
            case codeEnteredTxtThird:
                self.performSelector(#selector(StagingVC.setNextResponder(_:)), withObject: codeEnteredTxtSecond, afterDelay: 0.0)
            case codeEnteredTxtSecond:
                self.performSelector(#selector(StagingVC.setNextResponder(_:)), withObject: codeEnteredTxtFirst, afterDelay: 0.0)
            default: break
            }
        }
        return length <= 1
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case codeEnteredTxtFirst:
            arrayOfCodes[0] = textField.text!
        case codeEnteredTxtSecond:
            arrayOfCodes[1] = textField.text!
        case codeEnteredTxtThird:
            arrayOfCodes[2] = textField.text!
        case codeEnteredTxtFourth:
            arrayOfCodes[3] = textField.text!
        default:
            break
        }
    }
    
    func setNextResponder(nextResponder: UITextField) {
        nextResponder.becomeFirstResponder()
    }
    
    // The delegate function is called after the user presses the "OK" button from the AlertVC. 
    // Since Alert is a VC, StagingVC should have a way to know when user clicked on the button in AlertVC.
    // This is achieved via Protocols.
    func didPressOK(sender: UIButton) {
        self.leaveGame(sender)
    }
}
