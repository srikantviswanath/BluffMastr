//
//  Users.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/6/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class Users {
    
    static var users = Users()
    static var myScreenName: String!
    static var myCurrentAnswer: String!
    static var mycurrentVote: String!
    ///Array to keep track of voting history for the current player
    static var myVotingHistory = [String]()
    
    func createAnonymousUser(screenName: String) {
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion { user, error in
            if let error = error {
                NSLog("There was an error logging in anonymously" + error.localizedDescription)
            } else {
                // User successfully authenticated anonymously...
                let newUserDict = [SVC_PROVIDER: user!.providerID, SVC_SCREEN_NAME: screenName]
                FDataService.fDataService.REF_USERS.child(user!.uid).setValue(newUserDict)
            }
        }
    }
    
        
    func deleteAnonymousUser() {
        if let user = FIRAuth.auth()?.currentUser {
            user.deleteWithCompletion({ (error) in
                if let error = error {
                    NSLog("There was an error deleting anonymous user " + error.localizedDescription)
                } else {
                    //Account successfully deteled.
                    FDataService.fDataService.REF_USERS.child(user.uid).removeValue()
                }
            })
        } else {
            NSLog("[FIREBASE::FIRAUTH] Error fetching Current User.")
        }
    }
}