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
    var playersInRoom = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTable.delegate = self
        playersTable.dataSource = self
        
        switchLblsAfterViewLoad()
        
        if isGameCreator! {
            FDataService.fDataService.REF_GAMES.childByAppendingPath("\(Games.gameUID)/\(FB_GAME_MEMBERS)").observeEventType(.ChildAdded, withBlock: { snapshot in
                    if let screenName = snapshot.key {
                        self.playersInRoom.append(screenName)
                        self.playersTable.reloadData()
                        self.switchDataDependentLbls()
                    }
            })
            
        }
    }
    
    func switchDataDependentLbls(){
        if isGameCreator! {
            if self.playersInRoom.count < 3 {
                self.startBtn.enabled = false
                self.statusLbl.text = STATUS_NEED_MORE_PLAYERS
                self.createdGameCode.text = Games.sharedToken
            } else {
                self.startBtn.enabled = true
                self.statusLbl.text = STATUS_START_GAME
            }
        }
    }
    
    func switchLblsAfterViewLoad(){
        barTitle.text = screenTitle
        if isGameCreator! {
            joinerStaticLbl.hidden = true
            codeEnteredTxt.hidden = true
            joinBtn.hidden = true
        } else {
            createdGameCode.hidden = true
            creatorStaticLbl.hidden = true
            statusLbl.text = STATUS_WAITING_TO_START
            startBtn.hidden = true
        }
    }
    
    //TODO-> This code is being repeated. Solution??
    func showErrorMsg(title: String!, msg: String!){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    /*validate the entered code and enter this player in the game room*/
    @IBAction func joinGame(sender: UIButton!){
        var foundGameUID: String!
        if let enteredCode = codeEnteredTxt.text where enteredCode != "" {
            let refGames = FDataService.fDataService.REF_GAMES
            refGames.queryOrderedByChild(FB_SHARED_TOKEN).queryEqualToValue(enteredCode).observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    self.showErrorMsg(ERR_WRONG_CODE_TITLE, msg: ERR_WRONG_CODE_MSG)
                } else {
                    if let gameDict = snapshot.value as? Dictionary<String, AnyObject> {
                        foundGameUID = Array(gameDict.keys)[0]
                    }
                    let thisGameMembersRef = refGames.childByAppendingPath("\(foundGameUID)/\(FB_GAME_MEMBERS)")
                    thisGameMembersRef.updateChildValues([self.screenTitle:true], withCompletionBlock:{ error, ref in
                        if error != nil {
                            self.showErrorMsg(ERR_JOIN_GAME_TITLE, msg: "\(ERR_JOIN_GAME_MSG)\(enteredCode)")
                        } else {
                            self.playersInRoom.append(self.screenTitle)
                        }
                    })
                }
            })
            
        } else {
            showErrorMsg(ERR_GAMECODE_MISSING_TITLE, msg: ERR_GAMECODE_MISSING_MSG)
        }
    }
    
    @IBAction func leaveGame(sender: UIButton!){
        performSegueWithIdentifier(SEGUE_LEAVE_GAME, sender: nil)
    }
    
    /* UITableView delegate methods */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersInRoom.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = playersTable.dequeueReusableCellWithIdentifier(CELL_PLAYER_IN_ROOM) as? PlayerInRoomCell {
            cell.configureCell(playersInRoom[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
