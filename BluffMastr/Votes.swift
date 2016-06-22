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
    
    func listenForVotesCasted(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_VOTES.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { playerVoteSS in
            if let voteCasted = playerVoteSS.value as? String {
                Games.votesCastedForThisRound[playerVoteSS.key] = voteCasted
                completed()
            }
        })
    }
    
    /* Function to mimic the functionality of observeSingeEventType within a view controller */
    func stopListeningForPlayersVotes() {
        FDataService.fDataService.REF_VOTES.child(Games.gameUID).removeAllObservers()
    }
    
    /* Resets the client player's vote for the current round. Used in case of a tie*/
    func resetPlayerVote() {
        FDataService.fDataService.REF_VOTES.child(Games.gameUID).child(Users.myScreenName).removeValue()
    }
}