//
//  GameMembers.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/6/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class GameMembers {
    
    static var gameMembers = GameMembers()
    
    func addMemberToRoom(newMember: String!, gameID: String = Games.gameUID) {
        let gameMembersRef = FDataService.fDataService.REF_GAME_MEMBERS.childByAppendingPath(gameID)
        gameMembersRef.updateChildValues([newMember: true])
    }
    
    func observeNewMembersAdded() {
        FDataService.fDataService.REF_GAME_MEMBERS.childByAppendingPath(Games.gameUID).observeEventType(.ChildAdded, withBlock: { snapshot in
            if let screenName = snapshot.key {
                StagingVC.playersInRoom.append(screenName)
            }
        })
    }
}