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

let ref = FIRDatabase.database().reference()

class FDataService {
    
    static let fDataService = FDataService()
    
    private var _REF_BASE = ref
    private var _REF_GAMES = ref.child("games")
    private var _REF_USERS = ref.child("users")
    private var _REF_GAME_MEMBERS = ref.child("gameMembers")
    private var _REF_QUESTIONS = ref.child("questions")
    private var _REF_ANSWERS = ref.child("answers")
    private var _REF_CURRENT_ROUNDS = ref.child("currentRounds")
    private var _REF_LEADERBOARDS = ref.child("leaderboards")
    private var _REF_VOTES = ref.child("votes")
    private var _REF_READY_NEXT = ref.child("readyForNext")
    private var _REF_GHOST_PLAYERS = ref.child("ghostPlayers")
    private var _REF_FINAL_SCORES = ref.child("finalScores")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_GAMES: FIRDatabaseReference {
        return _REF_GAMES
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_GAME_MEMBERS: FIRDatabaseReference {
        return _REF_GAME_MEMBERS
    }
    
    var REF_QUESTIONS: FIRDatabaseReference {
        return _REF_QUESTIONS
    }
    
    var REF_ANSWERS: FIRDatabaseReference {
        return _REF_ANSWERS
    }
    
    var REF_CURRENT_ROUNDS: FIRDatabaseReference {
        return _REF_CURRENT_ROUNDS
    }
    
    var REF_LEADERBOARDS: FIRDatabaseReference {
        return _REF_LEADERBOARDS
    }
    
    var REF_VOTES: FIRDatabaseReference {
        return _REF_VOTES
    }
    
    var REF_READY_NEXT: FIRDatabaseReference {
        return _REF_READY_NEXT
    }
    
    var REF_GHOST_PLAYERS: FIRDatabaseReference {
        return _REF_GHOST_PLAYERS
    }
    
    var REF_FINAL_SCORES: FIRDatabaseReference {
        return _REF_FINAL_SCORES
    }
}





