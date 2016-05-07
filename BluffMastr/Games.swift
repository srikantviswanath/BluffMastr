//
//  Games.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/6/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class Games {
    
    
    static var gameUID: String!
    static var sharedToken: String!
    static var games = Games()
    
    func createGame(gameCaptain: String){
        let gameRef = FDataService.fDataService.REF_GAMES.childByAutoId()
        Games.gameUID = gameRef.key
        Games.sharedToken = Games.gameUID.substringFromIndex(Games.gameUID.endIndex.advancedBy(-6))
        gameRef.setValue([FB_SHARED_TOKEN: Games.sharedToken])
        setGameCaptain(gameCaptain)
    }
    
    func setGameCaptain(gameCaptain: String!) {
        let gameRef = FDataService.fDataService.REF_GAMES.childByAppendingPath(Games.gameUID)
        gameRef.updateChildValues([SERVICE_GAME_CAPTAIN: gameCaptain])
    }
}