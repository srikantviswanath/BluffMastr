//
//  Games.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/6/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

/*
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
 */

class Games {
    
    
    static var gameUID: String!
    static var sharedToken: String!
    static var games = Games()
    static var REF_GAMES_BASE = FDataService.fDataService.REF_GAMES
    
    func createGame(gameCaptain: String){
        let gameRef = Games.REF_GAMES_BASE.childByAutoId()
        Games.gameUID = gameRef.key
        Games.sharedToken = Games.gameUID.substringFromIndex(Games.gameUID.endIndex.advancedBy(-6))
        gameRef.setValue([FB_SHARED_TOKEN: Games.sharedToken])
        updateGame(SERVICE_GAME_CAPTAIN, person: gameCaptain)
    }
    
    func updateGame(attribute: String, person: String) {
        let gameRef = Games.REF_GAMES_BASE.childByAppendingPath(Games.gameUID)
        
        switch attribute {
        case SERVICE_GAME_CAPTAIN:
            gameRef.updateChildValues([SERVICE_GAME_CAPTAIN: person])
        case SERVICE_GAME_BLUFFMASTER:
            gameRef.updateChildValues([SERVICE_GAME_BLUFFMASTER: person])
        default:
            print("Internal Error in UpdateGame")
        }
    }
    
    func joinGame(enteredCode: String, gameSlave: String) {
        Games.REF_GAMES_BASE.queryOrderedByChild(FB_SHARED_TOKEN).queryEqualToValue(enteredCode).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    GameMembers.gameMembers.joinGameMembers([gameSlave: true], gameID: child.key!!)
                }
            } else {
                ErrorHandler.errorHandler.showErrorMsg(ERR_WRONG_CODE_TITLE, msg: ERR_WRONG_CODE_MSG)
            }
        })
    }
}