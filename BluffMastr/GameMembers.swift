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
    
    func joinGameMembers(newMember: [String:Bool], gameID: String = Games.gameUID) {
        let gameMembersRef = FDataService.fDataService.REF_GAME_MEMBERS.childByAppendingPath(gameID)
        gameMembersRef.updateChildValues(newMember)
    }
}