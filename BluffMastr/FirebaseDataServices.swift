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
    
    func createGame(gameMember: [String: String]) -> String {
        
        // https://<YOUR-FIREBASE-APP>.firebaseio.com/games/<auto-id>
        let gameRef = _REF_GAMES.childByAutoId()
        
        let gameID = gameRef.key
        let sharedTokenID = gameID.substringFromIndex(gameID.endIndex.advancedBy(-6))
        
        gameRef.setValue(["sharedToken": sharedTokenID])
        gameRef.updateChildValues((gameMember))
        
        return sharedTokenID
    }
}





