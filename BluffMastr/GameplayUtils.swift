//
//  GameplayUtils.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

func isPlayerBluffMastr() -> Bool{
    return Games.bluffMastr == Users.myScreenName
}

/* Evaluate the answer submitted by player. If answer not present(Typo?), return 0 */
func evaluateScore(answerSubmitted: String) -> String{
    for (score, value) in Games.answersDict {
        if value == answerSubmitted {
            return score
        }
    }
    return "0"
}