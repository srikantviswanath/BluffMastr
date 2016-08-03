//
//  GameMembers.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/6/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class GameMembers {
    
    static var gameMembers = GameMembers()
    static var playersInGameRoom = [String]()
    static var votedoutPlayers = [String]()
    
    func addMemberToRoom(newMember: String!, gameID: String = Games.gameUID) {
        let gameMembersRef = FDataService.fDataService.REF_GAME_MEMBERS.child(gameID)
        gameMembersRef.updateChildValues([newMember: true])
    }
    
    func deleteRoom() {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).removeValue()
    }
    
    /** Remove the :player: from the following REFs:
        - REF_GAME_MEMBERS
        - REF_LEADERBOARD
        - REF_USERS /* The user will be deleted in deleteAnonymousUser() */
        - REF_CURRENT_ROUNDS
        - REF_VOTES
     */
    func removePlayerFromRoom(player: String!, gameID: String = Games.gameUID) {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).child(player).removeValue()
        //FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).child(player).removeValue()
        FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).child(player).removeValue()
        FDataService.fDataService.REF_VOTES.child(Games.gameUID).child(player).removeValue()
    }
    
    /**************** GAME ROOM MEMBER LISTENER ****************/
    func observeNewMembersAdded(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { snapshot in
            let screenName = snapshot.key
            GameMembers.playersInGameRoom.append(screenName)
          completed()
        })
    }
    
    func observeMembersRemoved(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).observeEventType(.ChildRemoved, withBlock: { snapshot in
            let screenName = snapshot.key
            removePlayerFromRoomCache(screenName)
            completed()
        })
    }
    
    func observeMemberAddedOrRemoved(completed: GenericCompletionBlock) {
        GameMembers.gameMembers.observeNewMembersAdded { completed() }
        GameMembers.gameMembers.observeMembersRemoved { completed() }
    }
    
    func removeGameMemberListeners() {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).removeAllObservers()
    }
    
    /**************** END GAME ROOM MEMBER LISTENER ****************/
    
    func gameRoomIsRemoved(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_GAME_MEMBERS.observeSingleEventOfType(.ChildRemoved, withBlock: { snapshot in
            if snapshot.key == Games.gameUID {
                completed()
            }
        })
    }
    
    func removeObserverForGameRoom() {
        FDataService.fDataService.REF_GAME_MEMBERS.removeAllObservers()
    }
}