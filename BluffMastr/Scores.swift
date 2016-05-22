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
        FDataService.fDataService.REF_LEADERBOARDS.childByAppendingPath(Games.gameUID).setValue(leaderBoardDict)
    }
    
    func uploadPlayerScore(currentRoundScore: Int, completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_CURRENT_ROUNDS.childByAppendingPath(Games.gameUID).updateChildValues(
            [Users.myScreenName: currentRoundScore]
        )
        completed()
    }
    
    func accumulatePlayerScore(currentRoundScore: Int) {
        let playerLeaderboardRef = FDataService.fDataService.REF_LEADERBOARDS.childByAppendingPath(Games.gameUID).childByAppendingPath(Users.myScreenName)
        playerLeaderboardRef.observeSingleEventOfType(.Value, withBlock: {playerTotalSS in
            if let scoreTillNow = playerTotalSS.value as? Int! {
                playerLeaderboardRef.setValue(scoreTillNow + currentRoundScore)
            }
        })
    }
    
    /* This function is used to observe for each player's submission of answer to Firebase */
    func listenForPlayersSubmissions(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_CURRENT_ROUNDS.childByAppendingPath(Games.gameUID).observeEventType(.ChildAdded, withBlock: { playerAnswerSS in
            if let playerScore = playerAnswerSS.value as? Int {
                Games.playersSubmissions.append([playerAnswerSS.key: playerScore])
                completed()
            }
        })
    }
    
    func fetchLeaderboard(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_LEADERBOARDS.childByAppendingPath(Games.gameUID).observeSingleEventOfType(.Value, withBlock: { leaderboardSS in
            for child in (leaderboardSS.children.allObjects as? [FDataSnapshot])! {
                Games.leaderboard.append([child.key: (child.value as? Int)!])
            }
            completed()
        })
    }
}
