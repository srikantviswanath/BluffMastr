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
}
