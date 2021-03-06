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
    static var gameCreator: String!
    static var roundNumber: String!
    static var currentQuestionTitle: String!
    static var currentQuestionId: Int?
    ///To hold the actual answers for current question
    static var answersDict = Dictionary<String, String>()
    ///To hold players' answer submission for the current round
    static var playersSubmissions = [Dictionary<String, Int>]()
    ///To hold players' total scores for the game
    static var leaderboard = [Dictionary<String, Int>]()
    //To hold players' final scores after computing bonus/penalty
    static var finalScores = [Dictionary<String,Int>]()
    ///To hold the voter and his/her vote for the current round
    static var votesCastedForThisRound = Dictionary<String, String>()
    ///To hold the players who are ready to begin the next round
    static var playersReadyForNextRound = [String]()
    static var listenGameFBHandle: UInt?
    static var games = Games()
    static var REF_GAMES_BASE = FDataService.fDataService.REF_GAMES
    
    private func checkIfTokenIsAlreadyUsed(generatedToken: String, completed: GenericCompletionBlock) {
        Games.REF_GAMES_BASE.queryOrderedByChild(SVC_SHARED_TOKEN).queryEqualToValue(generatedToken).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                // collision occured.
                self.checkIfTokenIsAlreadyUsed(randomFourDigitString()){
                    completed() // this is parent block in createGame()
                }
            } else {
                Games.sharedToken = generatedToken
                completed() // the above child block is called.
            }
        })
    }
        
    func createGame(gameCaptain: String, completed: GenericCompletionBlock){
        let gameRef = Games.REF_GAMES_BASE.childByAutoId()
        Games.gameUID = gameRef.key
        
        checkIfTokenIsAlreadyUsed(randomFourDigitString()) {
            gameRef.setValue([SVC_SHARED_TOKEN: Games.sharedToken])
            self.updateGameInfo(SVC_GAME_CAPTAIN, person: gameCaptain, completed: {})
            Games.REF_GAMES_BASE.child(Games.gameUID).updateChildValues([SVC_GAME_BLUFFMASTER: false])
            GameMembers.gameMembers.addMemberToRoom(gameCaptain)
            completed()
        }
    }
    
    func updateGameInfo(attribute: String, person: String, gameDict:Dictionary<String, String>=[:], completed: GenericCompletionBlock) {
        let gameRef = Games.REF_GAMES_BASE.child(Games.gameUID)
        
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
    
    func joinGame(enteredCode: String, gameSlave: String, sucessCompleted: (Bool) -> (), failedCompleted: GenericCompletionBlock) {
        Games.REF_GAMES_BASE.queryOrderedByChild(SVC_SHARED_TOKEN).queryEqualToValue(enteredCode).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    Games.gameUID = child.key!!
                    Users.users.isScreenNameAlreadyTaken(gameSlave, completed: { (isTaken) in
                        if isTaken {
                            sucessCompleted(true)
                        } else {
                            GameMembers.gameMembers.addMemberToRoom(gameSlave)
                            sucessCompleted(false)
                        }
                    })
                }
            } else {
                failedCompleted()
            }
        })
    }
    
    func invalidateTokenUponGameStart(sharedToken: String) {
        Games.REF_GAMES_BASE.child(Games.gameUID).child("sharedToken").removeValue()
    }
    
    func listenToGameChanges(attribute: String, completed: GenericCompletionBlock) {
        Games.listenGameFBHandle = Games.REF_GAMES_BASE.child(Games.gameUID).observeEventType(.ChildChanged, withBlock: { snapshot in
            switch attribute {
            case SVC_GAME_BLUFFMASTER:
                if snapshot.key == attribute {Games.bluffMastr = snapshot.value as? String}
            case SVC_CURRENT_QUESTION:
                if snapshot.key == attribute {
                    Games.currentQuestionId = Int((snapshot.value as? String)!)!
                    Questions.completedQuestionIds.append(Games.currentQuestionId!)
                }
            default:
                print("Swag! The gutles don't know what to do yet!Come back later, with a 6 pack")
            }
            completed()
        })
    }
    
    func removeObserverForListenToGameChanges() {
        if let handle = Games.listenGameFBHandle {
            Games.REF_GAMES_BASE.child(Games.gameUID).removeObserverWithHandle(handle)
        }
    }
    
    ///This method will be useful when .Value observance is required, i.e. snapshots at different sample times
    func fetchGameSnapshot(completed: GenericCompletionBlock) {
        Games.REF_GAMES_BASE.child(Games.gameUID).observeSingleEventOfType(.Value, withBlock: { gameSS in
            if let gameChildren = gameSS.children.allObjects as? [FIRDataSnapshot] {
                for child in gameChildren {
                    switch child.key {
                    case SVC_CURRENT_QUESTION:
                        Games.currentQuestionId = Int((child.value as? String)!)!
                        Questions.completedQuestionIds.append(Games.currentQuestionId!)
                    case SVC_GAME_BLUFFMASTER:
                        Games.bluffMastr = child.value as? String
                    case SVC_GAME_ROUND:
                        Games.roundNumber = child.value as? String
                    default:
                        print("Yolo! Default behavious for observing .Value snapshot comes here. Stay tuned")
                    }
                }
                completed()
            }
        })
    }
    
    /**
     Method to attempt to increment the round number at server. Firebase transaction block is run to take care of concurrency
    */
    func attemptToSetDataForNextRound(completed: GenericCompletionBlock) {
        let roundRef = FDataService.fDataService.REF_GAMES.child(Games.gameUID).child(SVC_GAME_ROUND)
        roundRef.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            var roundNumberAtServer = currentData.value as? String //This value should never be nil
            if roundNumberAtServer == nil {
                roundNumberAtServer = "\(0)"
            }
            if Int(roundNumberAtServer!) == Int(Games.roundNumber) {
                currentData.value = "\(Int(roundNumberAtServer!)! + 1 )"
                return FIRTransactionResult.successWithValue(currentData)
            } else {
                return FIRTransactionResult.abort()
            }
        }){ error, commited, snapshot in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if commited {
                    Games.REF_GAMES_BASE.child(Games.gameUID).updateChildValues(randomizeNextRoundData(), withCompletionBlock: {_,_ in 
                        completed()
                    })
                } else {
                    if let _ = snapshot?.value as? NSNull{ //Firebase error. roundNumberAtServer came back as nil in the above block
                        roundRef.observeSingleEventOfType(.Value, withBlock: { roundSS in
                            if let roundNumberAtServer = roundSS.value as? String { //Check if other clients were able to successfully update server
                                if Int(roundNumberAtServer) != Int(Games.roundNumber) {
                                    completed()
                                } else {
                                    AlertHandler.alert.showAlertMsg("Snap :(", msg: "It's not you It's us. Could not update server. Try again")
                                }
                            }
                        })
                        
                    } else { //One of the other clients already updated server successfully
                        completed()
                    }
                }
            }
        }
    }

    func deleteGame() {
        FDataService.fDataService.REF_GAMES.child(Games.gameUID).removeValue()
    }
}