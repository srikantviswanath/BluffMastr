//
//  Votes.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/24/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class Votes {
    static var votes = Votes()
    
    func submitVote(votedFor: String) {
        FDataService.fDataService.REF_VOTES.child(Games.gameUID).updateChildValues([Users.myScreenName: votedFor])
    }
}