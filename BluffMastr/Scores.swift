//
//  Scores.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/16/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class Scores {
    
    static var scores = Scores()
    static var myLeaderboardRef = FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).child(Users.myScreenName)
    static var myFinalScoreRef = FDataService.fDataService.REF_FINAL_SCORES.child(Games.gameUID).child(Users.myScreenName)
    
    func setScoreRefs() {
        Scores.myLeaderboardRef = FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).child(Users.myScreenName)
        Scores.myFinalScoreRef = FDataService.fDataService.REF_FINAL_SCORES.child(Games.gameUID).child(Users.myScreenName)
    }
    
    func resetLeaderboard() {
        var leaderBoardDict = Dictionary<String, Int>()
        for player in GameMembers.playersInGameRoom {
            leaderBoardDict[player] = 0
        }
        FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).setValue(leaderBoardDict)
    }
    
    func uploadPlayerScore(currentRoundScore: Int, completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).updateChildValues(
            [Users.myScreenName: currentRoundScore]
        )
        completed()
    }
    
    func accumulatePlayerScore(currentRoundScore: Int, completed: GenericCompletionBlock) {
        Scores.myLeaderboardRef.observeSingleEventOfType(.Value, withBlock: {playerTotalSS in
            if let scoreTillNow = playerTotalSS.value as? Int! {
                Scores.myLeaderboardRef.setValue(scoreTillNow + currentRoundScore, withCompletionBlock: {_,_ in
                    completed()
                })
            }
        })
    }
    
    ///This function is used to observe for each player's submission of answer to Firebase
    func listenForPlayersSubmissions(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { playerAnswerSS in
            if let playerScore = playerAnswerSS.value as? Int {
                Games.playersSubmissions.append([playerAnswerSS.key: playerScore])
                if (Games.playersSubmissions.count > 1) { // sort closure must at least have two values to perform sorting.
                    Games.playersSubmissions.sortInPlace({ Array($0.values)[0] > Array($1.values)[0] }) // Descending order sort.
                }
                completed()
            }
        })
    }
    
    ///This function is used to observe for each player's submission of their final score to Firebase
    func listenForFinalScores(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_FINAL_SCORES.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { playerFinalScoreSS in
            if let playerFinalScore = playerFinalScoreSS.value as? Int {
                Games.finalScores.append([playerFinalScoreSS.key: playerFinalScore])
                if (Games.finalScores.count > 1) { // sort closure must at least have two values to perform sorting.
                    Games.finalScores.sortInPlace({ Array($0.values)[0] > Array($1.values)[0] }) // Descending order sort.
                }
                completed()
            }
        })
    }
    
    ///Usually call this method at the terminal state of a node's lifecycle in a ViewController
    func stopListeningForPlayerScores() {
        FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).removeAllObservers()
    }
    
    func stopListeningForFinalScores() {
        FDataService.fDataService.REF_FINAL_SCORES.child(Games.gameUID).removeAllObservers()
    }
    
    
    func fetchLeaderboardOnce(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).queryOrderedByValue().observeSingleEventOfType(.Value, withBlock: { leaderboardSS in
            for child in (leaderboardSS.children.allObjects as? [FIRDataSnapshot])!.reverse() {
                Games.leaderboard.append([child.key: (child.value as? Int)!])
            }
            completed()
        })
    }
    
    func listenToLeaderboardChanges(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).queryOrderedByValue().observeEventType(.Value, withBlock: { leaderboardSS in
            Games.leaderboard = [Dictionary<String, Int>]()
            for child in (leaderboardSS.children.allObjects as? [FIRDataSnapshot])!.reverse() {
                Games.leaderboard.append([child.key: (child.value as? Int)!])
            }
            completed()
        })
    }
    
    func fetchFinalScoreOfOpponent(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_FINAL_SCORES.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { playerFinalScoreSS in
            if Users.myScreenName != playerFinalScoreSS.key {
                Users.myOpponentFinalScore = playerFinalScoreSS.value as? Int
                completed()
            }
        })
    }
}
