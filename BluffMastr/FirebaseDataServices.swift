//
//  FirebaseDataServices.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

//
//  FirebaseDataServices.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://bluffmastr.firebaseio.com/"
let FB_SHARED_TOKEN = "sharedToken"
let FB_GAME_MEMBERS = "gameMembers"
let FB_SCREEN_NAME = "screenName"

class FDataService {
    
    static let fDataService = FDataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_GAMES = Firebase(url: "\(URL_BASE)" + "games")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)" + "users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_GAMES: Firebase {
        return _REF_GAMES
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    func createNewUser(authData: FAuthData!, userDict: [String: String!]) {
        
        // https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
        _REF_USERS.childByAppendingPath(authData.uid).setValue(userDict)
    }
    
    func createGame(gameCaptain: String) -> Dictionary<String, String> {
        let gameRef = REF_GAMES.childByAutoId()
        let gameID = gameRef.key
        let sharedTokenID = gameID.substringFromIndex(gameID.endIndex.advancedBy(-6))
        
        gameRef.setValue([FB_SHARED_TOKEN: sharedTokenID])
        gameRef.childByAppendingPath(FB_GAME_MEMBERS).updateChildValues([gameCaptain:true])
        return [FB_SHARED_TOKEN: sharedTokenID, GAME_ID: gameID]
    }
}





