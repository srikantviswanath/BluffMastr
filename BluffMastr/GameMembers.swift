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
    
    func addMemberToRoom(newMember: String!, gameID: String = Games.gameUID) {
        let gameMembersRef = FDataService.fDataService.REF_GAME_MEMBERS.child(gameID)
        gameMembersRef.updateChildValues([newMember: true])
    }
    
    func deleteRoom() {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).removeValue()
    }
    
    /* Remove the player from REFs whise scope is not limited to each round 
        - REF_GAME_MEMBERS
        - REF_LEADERBOARD
        - REF_USERS
     */
    func removePlayerFromRoom(player: String!, gameID: String = Games.gameUID) {
        FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).child(player).removeValue()
        FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).child(Users.myScreenName).removeValue()
        FDataService.fDataService.REF_USERS.child(Games.gameUID).child(Users.myScreenName).removeValue()
        if player == Games.bluffMastr {
            Games.bluffMastr = nil
        }
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
}