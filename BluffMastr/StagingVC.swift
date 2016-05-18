//
//  StagingVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class StagingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var barTitle: UILabel!
    @IBOutlet weak var joinerStaticLbl: UILabel!
    @IBOutlet weak var codeEnteredTxt: UITextField!
    @IBOutlet weak var creatorStaticLbl: UILabel!
    @IBOutlet weak var createdGameCode: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var playersTable: UITableView!
    
    var isGameCreator: Bool!
    var screenTitle: String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTable.delegate = self
        playersTable.dataSource = self
        
        switchLblsAfterViewLoad()
        
        if isGameCreator! {
            GameMembers.gameMembers.observeNewMembersAdded {
                self.playersTable.reloadData()
                self.switchDataDependentLbls()
            }
        }
    }
    
    /* =======View changing funcs after create/join game and depending on #players======== */
    
    func switchLblsAfterViewLoad(){
        barTitle.text = screenTitle
        if isGameCreator! {
            joinerStaticLbl.hidden = true
            codeEnteredTxt.hidden = true
            joinBtn.hidden = true
        } else {
            createdGameCode.hidden = true
            creatorStaticLbl.hidden = true
            statusLbl.text = ""
            startBtn.hidden = true
        }
    }

    func switchDataDependentLbls(){
        if (isGameCreator!) {
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
        codeEnteredTxt.hidden = true
        joinerStaticLbl.text = CMT_GAME_PREP
    }

    /*==========================IBActions==============================*/
    
    /*validate the entered code and enter this player in the game room*/
    @IBAction func joinGame(sender: UIButton!){
        self.view.endEditing(true)
        if let enteredCode = codeEnteredTxt.text where enteredCode != "" {
            Games.games.joinGame(enteredCode, gameSlave: self.screenTitle) {
                GameMembers.gameMembers.observeNewMembersAdded {
                    self.playersTable.reloadData()
                    self.changeViewAfterJoin()
                }
                Users.myScreenName = self.screenTitle
                Games.games.listenToGameChanges(SVC_GAME_BLUFFMASTER) { // Game starts as soon as bluffMastr is set for the game
                    self.performSegueWithIdentifier(SEGUE_START_GAME, sender: nil)
                }
            }
        } else {
            ErrorHandler.errorHandler.showErrorMsg(ERR_GAMECODE_MISSING_TITLE, msg: ERR_GAMECODE_MISSING_MSG)
        }
    }
    
    @IBAction func startGame(sender: UIButton) {
        // Mark a random member as BluffMaster
        if GameMembers.playersInGameRoom.count < MIN_PLAYERS {
            ErrorHandler.errorHandler.showErrorMsg(ERR_NEED_PLAYERS_TITLE, msg: ERR_NEED_PLAYERS_MSG)
            return
        }
        let randomPlayerNum = Int(arc4random_uniform(UInt32(GameMembers.playersInGameRoom.count)))
        let randomQuestionNum = Int(arc4random_uniform(UInt32(2)))
        let bluffMaster = GameMembers.playersInGameRoom[randomPlayerNum]
        Games.games.updateGameInfo(SVC_GAME_DICT, person: "", gameDict: [SVC_GAME_BLUFFMASTER: bluffMaster, SVC_CURRENT_QUESTION: "\(randomQuestionNum)"]) {
            self.performSegueWithIdentifier(SEGUE_START_GAME, sender: nil)
            Games.bluffMastr = bluffMaster
        }
    }
    
    @IBAction func leaveGame(sender: UIButton!){
        performSegueWithIdentifier(SEGUE_LEAVE_GAME, sender: nil)
    }
    
    /* ==================UITableView delegate methods ============= */
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
        
}
