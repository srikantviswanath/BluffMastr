//
//  Games.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/6/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class Games {
    
    static var gameUID: String!
    static var bluffMastr: String?
    static var sharedToken: String!
    static var currentQuestionTitle: String!
    static var currentQuestionId: Int!
    static var answersDict = Dictionary<String, String>() //To hold the actual answers for current question
    static var playersSubmissions = [Dictionary<String, Int>]() //To hold players' answer submission for the current round
    static var leaderboard = [Dictionary<String, Int>]()
    static var games = Games()
    static var REF_GAMES_BASE = FDataService.fDataService.REF_GAMES
    
    func createGame(gameCaptain: String){
        let gameRef = Games.REF_GAMES_BASE.childByAutoId()
        Games.gameUID = gameRef.key
        Games.sharedToken = Games.gameUID.substringFromIndex(Games.gameUID.endIndex.advancedBy(-6))
        gameRef.setValue([SVC_SHARED_TOKEN: Games.sharedToken])
        updateGameInfo(SVC_GAME_CAPTAIN, person: gameCaptain, completed: {})
        Games.REF_GAMES_BASE.childByAppendingPath(
            Games.gameUID).updateChildValues([SVC_GAME_BLUFFMASTER: false]
        )
        GameMembers.gameMembers.addMemberToRoom(gameCaptain)
    }
    
    func updateGameInfo(attribute: String, person: String, gameDict:Dictionary<String, String>=[:], completed: GenericCompletionBlock) {
        let gameRef = Games.REF_GAMES_BASE.childByAppendingPath(Games.gameUID)
        
        switch attribute {
        case SVC_GAME_CAPTAIN:
            gameRef.updateChildValues([SVC_GAME_CAPTAIN: person])
        case SVC_GAME_BLUFFMASTER:
            gameRef.updateChildValues([SVC_GAME_BLUFFMASTER: person])
        case SVC_GAME_DICT:
            gameRef.updateChildValues(gameDict)
        default:
            print("Internal Error in UpdateGame")
        }
        completed()
    }
    
    func joinGame(enteredCode: String, gameSlave: String, completed: GenericCompletionBlock) {
        Games.REF_GAMES_BASE.queryOrderedByChild(SVC_SHARED_TOKEN).queryEqualToValue(enteredCode).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    Games.gameUID = child.key!!
                    GameMembers.gameMembers.addMemberToRoom(gameSlave)
                }
                completed()
            } else {
                ErrorHandler.errorHandler.showErrorMsg(ERR_WRONG_CODE_TITLE, msg: ERR_WRONG_CODE_MSG)
                print("Couldnt add member to gameRoom")
            }
        })
    }
    
    func listenToGameChanges(attribute: String, completed: GenericCompletionBlock) {
        Games.REF_GAMES_BASE.childByAppendingPath(Games.gameUID).observeEventType(.ChildChanged, withBlock: { snapshot in
            switch attribute {
            case SVC_GAME_BLUFFMASTER:
                if snapshot.key == attribute {Games.bluffMastr = snapshot.value as? String}
            case SVC_CURRENT_QUESTION:
                if snapshot.key == attribute {Games.currentQuestionId = Int((snapshot.value as? String)!)}
            default:
                print("Swag! The gutles don't know what to do yet!Come back later, with a 6 pack")
            }
            completed()
        })
    }
    
    /* This method will be useful when .Value observance is required, i.e. snapshots at different sample times */
    func fetchGameSnapshot(completed: GenericCompletionBlock) {
        Games.REF_GAMES_BASE.childByAppendingPath(Games.gameUID).observeEventType(.Value, withBlock: { gameSS in
            if let gameChildren = gameSS.children.allObjects as? [FDataSnapshot] {
                for child in gameChildren {
                    switch child.key {
                    case SVC_CURRENT_QUESTION:
                        Games.currentQuestionId = Int((child.value as? String)!)
                    case SVC_GAME_BLUFFMASTER:
                        Games.bluffMastr = child.value as? String
                    default:
                        print("Yolo! Default behavious for observing .Value snapshot comes here. Stay tuned")
                    }
                }
                completed()
            }
        })
    }
}