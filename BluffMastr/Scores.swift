//
//  Scores.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/16/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class Scores {
    
    static var scores = Scores()
    
    func uploadPlayerScore(score: Int) {
        FDataService.fDataService.REF_CURRENT_ROUNDS.childByAppendingPath(Games.gameUID).updateChildValues(
            [Users.myScreenName: score]
        )
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
}
