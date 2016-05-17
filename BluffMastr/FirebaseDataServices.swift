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

let URL_BASE = "https://bluffmastr.firebaseio.com"

class FDataService {
    
    static let fDataService = FDataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_GAMES = Firebase(url: "\(URL_BASE)/games")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    private var _REF_GAME_MEMBERS = Firebase(url: "\(URL_BASE)/gameMembers")
    private var _REF_QUESTIONS = Firebase(url: "\(URL_BASE)/questions")
    private var _REF_ANSWERS = Firebase(url: "\(URL_BASE)/answers")
    private var _REF_CURRENT_ROUNDS = Firebase(url: "\(URL_BASE)/currentRounds")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_GAMES: Firebase {
        return _REF_GAMES
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_GAME_MEMBERS: Firebase {
        return _REF_GAME_MEMBERS
    }
    
    var REF_QUESTIONS: Firebase {
        return _REF_QUESTIONS
    }
    
    var REF_ANSWERS: Firebase {
        return _REF_ANSWERS
    }
    
    var REF_CURRENT_ROUNDS: Firebase {
        return _REF_CURRENT_ROUNDS
    }
    
}





