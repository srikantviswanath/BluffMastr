//
//  Constants.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import UIKit

/* Custom closures*/

typealias GenericCompletionBlock = () -> ()

/* UI Elements constants */

let SHADOW_COLOR: CGFloat = 155.0/255.0

/* Segue and TableViewCell constants */

let SEGUE_CREATE_JOIN_GAME = "CreateOrJoinGame"
let SEGUE_LEAVE_GAME = "LeaveGame"
let CELL_PLAYER_IN_ROOM = "PlayerInRoomCell"

/* Error Messages */

let ERR_SCREENNAME_MISSING_TITLE = "ScreenName Missing"
let ERR_SCREENNAME_MISSIN_MSG = "You need to put on your bluffing name"
let ERR_GAMECODE_MISSING_TITLE = "Game Code Missing"
let ERR_GAMECODE_MISSING_MSG = "Kallu kakulu dobbeya??"
let ERR_WRONG_CODE_TITLE = "Incorrect Gamecode"
let ERR_WRONG_CODE_MSG = "Either you or your friend are smoking something fishy"
let ERR_JOIN_GAME_TITLE = "Error Joining Game"
let ERR_JOIN_GAME_MSG = "Please try again later. Could not join the room with code"

/* Statuses */

let STATUS_WAITING_TO_START = "Waiting for Captain to start the game..."
let STATUS_NEED_MORE_PLAYERS = "Waiting for more players to join..."
let STATUS_START_GAME = "Begin the Bluff Marathon"

/* Comments */

let CMT_GAME_PREP = "Hold your breath. You could be the next BluffMastr!"

/* Service Constants */

let SVC_GAME_CAPTAIN = "gameCaptain"
let SVC_GAME_BLUFFMASTER = "gameBluffMaster"
let SVC_PROVIDER = "provider"
let SVC_SCREEN_NAME = "screenName"
let SVC_SHARED_TOKEN = "sharedToken"


