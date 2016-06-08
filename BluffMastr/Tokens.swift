//
//  Tokens.swift
//  BluffMastr
//
//  Created by Nitin Jami on 6/5/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class Tokens {
    static var tokens = Tokens()
    static var REF_TOKENS_BASE = FDataService.fDataService.REF_TOKENS

    func getToken() {
        Tokens.REF_TOKENS_BASE.child(randomIntTypeString()).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                print("found")
            } else {
                print("Internal Error")
            }
        })
    }
}