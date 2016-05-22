//
//  GameplayUtils.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import GameplayKit

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

func getScorePhrase(playerScore: Int) -> String {
    if playerScore <= 3 {
        return STATUS_SCORE_LESS_THAN_3
    } else if (playerScore > 3 && playerScore < 7) {
        return STATUS_SCORE_3_TO_7
    } else {
        return STATUS_SCORE_MORE_THAN_7
    }
}

// https://www.hackingwithswift.com/read/35/3/generating-random-numbers-with-gameplaykit-gkrandomsource
func getRandom(upperBound: Int) -> Int {
    let source = GKMersenneTwisterRandomSource()
    return source.nextIntWithUpperBound(upperBound)
}

func randomRangeArray(max: Int) -> [Int] {
    var randomArray = [Int]()
    while randomArray.count < 10 {
        let number = getRandom(max) + 1
        if !randomArray.contains(number) {
            randomArray.append(number)
        }
    }
    return randomArray
}