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
    
    func createAnonymousUser(screenName: String) {
        
        FDataService.fDataService.REF_BASE.authAnonymouslyWithCompletionBlock { error, authData in
            if error != nil {
                NSLog("There was an error logging in anonymously")
            } else {
                // User successfully authenticated anonymously...
                let newUserDict = [SVC_PROVIDER: authData.provider, SVC_SCREEN_NAME: screenName]
                FDataService.fDataService.REF_USERS.childByAppendingPath(authData.uid).setValue(newUserDict)
            }
        }
    }
}