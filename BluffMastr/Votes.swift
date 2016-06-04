//
//  Votes.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/24/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class Votes {
    static var votes = Votes()
    
    func submitVote(votedFor: String, completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_VOTES.child(Games.gameUID).updateChildValues([Users.myScreenName: votedFor], withCompletionBlock: { err, fDB in
            if err != nil {ErrorHandler.errorHandler.showErrorMsg(ERR_VOTE_ABSENT_TITLE, msg: ERR_VOTE_ABSENT_MSG)}
            else {completed()}
            }
        )
    }
}