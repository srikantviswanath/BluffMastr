//
//  GameplayUtils.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

func isPlayerBluffMastr() -> Bool{
    return Games.bluffMastr == Users.myScreenName
}