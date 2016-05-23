//
//  Constants.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import UIKit

/* Gameplay constants */
let MIN_PLAYERS = 1
let ANSWER_ABSENT_FROM_LIST = 0

/* Custom closures*/

typealias GenericCompletionBlock = () -> ()

/* UI Elements constants */

let SHADOW_COLOR: CGFloat = 155.0/255.0

/* Segue and TableViewCell constants */

let SEGUE_CREATE_JOIN_GAME = "CreateOrJoinGame"
let SEGUE_LEAVE_GAME = "LeaveGame"
let SEGUE_START_GAME = "StartGame"
let SEGUE_FETCH_SCORE = "FetchScore"
let SEGUE_REVEAL_ANSWERS = "RevealAnswers"
let SEGUE_BLUFFMASTR_CHEAT = "CheatAnswers"
let SEGUE_SHOW_LEADERBOARD = "ShowLeaderboard"
let SEGUE_TO_VOTEOUT = "Voteout"

let CUSTOM_CELL = "CustomTableViewCell"
let THIS_ROUND_CELL = "ThisRoundCell"

/* Error Messages */

let ERR_SCREENNAME_MISSING_TITLE = "ScreenName Missing"
let ERR_SCREENNAME_MISSIN_MSG = "You need to put on your bluffing name"
let ERR_GAMECODE_MISSING_TITLE = "Game Code Missing"
let ERR_GAMECODE_MISSING_MSG = "Kallu kakulu dobbeya??"
let ERR_WRONG_CODE_TITLE = "Incorrect Gamecode"
let ERR_WRONG_CODE_MSG = "Either you or your friend are smoking something fishy"
let ERR_JOIN_GAME_TITLE = "Error Joining Game"
let ERR_JOIN_GAME_MSG = "Please try again later. Could not join the room with code"
let ERR_NEED_PLAYERS_TITLE = "Patience!"
let ERR_NEED_PLAYERS_MSG = "Need \(MIN_PLAYERS) or more players to enjoy bluffin'"
let ERR_TYPO_TITLE = "Typo"
let ERR_TYPO_MSG = "Got to pick one from the given list!"
let ERR_MISISNG_ANSWER_TITLE = "Answer Missing"
let ERR_MISSING_ANSWER_MSG = "Tried hard, but could not read your mind. Please enter your answer"

/* Statuses */

let STATUS_WAITING_TO_START = "Waiting for Captain to start the game..."
let STATUS_NEED_MORE_PLAYERS = "Waiting for more players to join..."
let STATUS_START_GAME = "Begin the Bluff Marathon"
let STATUS_INNOCENT_TITLE = "Your heart is pure"
let STATUS_INNOCENT_MSG = "You are not the BluffMastr. Put on your thinking hat, need to catch the BluffMastr"
let STATUS_BLUFFMATR_TITLE = "Muhahaha"
let STATUS_BLUFFMATR_MSG = "Time to Bluff and take your friends for a ride"
let STATUS_SCORE_LESS_THAN_3 = "Not Bad."
let STATUS_SCORE_3_TO_7 = "Good Job."
let STATUS_SCORE_MORE_THAN_7 = "Great Going."
let STATUS_WAITING_ALL_ANSWERS = "Waitin for everyone to answer..."
let STATUS_LAST_ROUND_SCORES = "Scores for this round:"




/* Comments */

let CMT_GAME_PREP = "Hold your breath. You could be the next BluffMastr!"
let MOST_COMMON = "(Most Common)"
let LEAST_COMMON = "(Least Common)"

/* Service Constants */

let SVC_GAME_CAPTAIN = "gameCaptain"
let SVC_GAME_BLUFFMASTER = "gameBluffMaster"
let SVC_PROVIDER = "provider"
let SVC_SCREEN_NAME = "screenName"
let SVC_SHARED_TOKEN = "sharedToken"
let SVC_GAME_DICT = "genericGameDict"
let SVC_CURRENT_QUESTION = "currentQuestion"
let SVC_QUESTION_TITLE = "title"


