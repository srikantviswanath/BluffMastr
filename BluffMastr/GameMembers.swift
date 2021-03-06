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
    static var originalPlayersAtGameStart = [String]()
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
            GameMembers.originalPlayersAtGameStart.append(screenName)
            GameMembers.playersInGameRoom.append(screenName)
          completed()
        })
    }
    
    //TODO: Before game bigins, originalPplayersAtGame start should be reduced upon players leaving, however it should not be reduced upon voteouts
    
    func observeMembersRemoved(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).observeEventType(.ChildRemoved, withBlock: { snapshot in
            let screenName = snapshot.key
            //GameMembers.originalPlayersAtGameStart = GameMembers.originalPlayersAtGameStart.filter { $0 != screenName}
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
    
    func observeGhostPlayersAdded(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_GHOST_PLAYERS.child(Games.gameUID).observeEventType(.ChildAdded, withBlock: { ghostPlayerSS in
            GameMembers.votedoutPlayers.append(ghostPlayerSS.key)
            completed()
        })
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