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
    
    func accumulatePlayerScore(currentRoundScore: Int) {
        let playerLeaderboardRef = FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).child(Users.myScreenName)
        playerLeaderboardRef.observeSingleEventOfType(.Value, withBlock: {playerTotalSS in
            if let scoreTillNow = playerTotalSS.value as? Int! {
                playerLeaderboardRef.setValue(scoreTillNow + currentRoundScore)
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
    
    ///Usually call this method at the terminal state of a node's lifecycle in a ViewController
    func stopListeningForPlayerScores() {
        FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).removeAllObservers()
    }
    
    func fetchLeaderboard(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).queryOrderedByValue().observeSingleEventOfType(.Value, withBlock: { leaderboardSS in
            for child in (leaderboardSS.children.allObjects as? [FIRDataSnapshot])!.reverse() {
                Games.leaderboard.append([child.key: (child.value as? Int)!])
            }
            completed()
        })
    }
}
