//
//  ServicesUtil.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 6/20/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation


func listenForNextRoundReadiness(completed: GenericCompletionBlock) {
    FDataService.fDataService.REF_READY_NEXT.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { readyPlayerSS in
        let playerName = readyPlayerSS.key
        Games.playersReadyForNextRound.append(playerName)
        completed()
    })
}

func stopListeningForPlayersReadiness() {
    FDataService.fDataService.REF_READY_NEXT.child(Games.gameUID).removeAllObservers()
}

func resetReadiness() {
    FDataService.fDataService.REF_READY_NEXT.child(Games.gameUID).child(Users.myScreenName).removeValue()
}

/** Method to show readiness for next round by cleaning up last round's cached values, values at server and submitting to REF_READY_NEXT/gameUID
 - Also runs a transaction block so that the first person ready for next round will set the next question and
 BluffMastr if voted out in previous round
 */
func readyForNextRound() {
    FDataService.fDataService.REF_READY_NEXT.child(Games.gameUID).updateChildValues([Users.myScreenName: true])
    Games.answersDict = Dictionary<String, String>()
    Games.playersSubmissions = [Dictionary<String, Int>]()
    Games.leaderboard = [Dictionary<String, Int>]()
    Games.votesCastedForThisRound = Dictionary<String, String>()
    FDataService.fDataService.REF_VOTES.child(Games.gameUID).child(Users.myScreenName).removeValue()
    FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).child(Users.myScreenName).removeValue()
    Games.games.attemptToSetDataForNextRound()
}
