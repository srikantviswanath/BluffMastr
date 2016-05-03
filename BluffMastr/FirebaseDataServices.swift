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
     var _REF_USER = Firebase(url: "\(URL_BASE)users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
}


