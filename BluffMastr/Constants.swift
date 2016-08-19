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
var TOTAL_QUESTIONS_AT_FIREBASE = 0 /*this is no longer a constant. total questions will be modified in the firbase and should be updated in the App*/
let BONUS_BLUFFMASTR_SURVIVAL = 5
let BONUS_VOTED_AGAINST_BLUFFMASTR = 3
let PENALTY_VOTED_AGAINST_INNOCENT_PLAYER = -5
let BONUS_PENALTY_REASON = [
    BONUS_BLUFFMASTR_SURVIVAL: "BluffMastr bonus", BONUS_VOTED_AGAINST_BLUFFMASTR: " for catching BluffMastr",
    PENALTY_VOTED_AGAINST_INNOCENT_PLAYER: " for not catching BluffMastr"
]
let IS_TUTORIAL_SHOWN = "isTutorialShown"
let SCREEN_NAME = "screenname"

/* Custom closures*/

typealias GenericCompletionBlock = () -> ()

/* UI Elements constants */

let COLOR_THEME = 0xF44336
let SHADOW_COLOR: CGFloat = 155.0/255.0
let COLOR_ELECTED_ANSWER = 0x00BCD4
let COLOR_HELP_MODAL_BG = 0xFF1744

/* BUTTON TITLES */
let BTN_VOTE_AGAIN = "Vote Again"
let BTN_NEXT_ROUND = "Ready >"
let BTN_HOME = "Home"
let BTN_DECLARE_VERDICT = "Verdict >"
let BTN_VOTEOUT = "VOTEOUT"
let BTN_GRAVEYARD = "Graveyard >"

/* Audio files*/
let AUDIO_BLUFFMASTR_VOTEDOUT = "bluffmastr_voted_out"
let AUDIO_INNOCENT_VOTEDOUT = "wrong_vote_out"
let AUDIO_GAME_OVER = "game_over"
let AUDIO_SHOW_SCORE = "score_swoosh"
let AUDIO_BONUS = "bonus"
let AUDIO_PENALTY = "penalty"
let AUDIO_PLAYER_VOTEDOUT = "player_votedout"

/* Segue and TableViewCell constants */

let SEGUE_CREATE_JOIN_GAME = "CreateOrJoinGame"
let SEGUE_LEAVE_GAME = "LeaveGame"
let SEGUE_START_GAME = "StartGame"
let SEGUE_HOME_GAME = "HomeGame"
let SEGUE_HELP_FOR_QUESTIONVC = "helpForQuestionVC"
let SEGUE_FETCH_SCORE = "FetchScore"
let SEGUE_REVEAL_ANSWERS = "RevealAnswers"
let SEGUE_BLUFFMASTR_CHEAT = "CheatAnswers"
let SEGUE_SHOW_LEADERBOARD = "ShowLeaderboard"
let SEGUE_TO_VOTEOUT = "Voteout"
let SEGUE_TO_VOTE_RESULT = "VoteResult"
let SEGUE_REVOTE = "Revote"
let SEGUE_VOTEDOUT_HOME = "VotedResultToLanding"
let SEGUE_START_NEXT_ROUND = "StartNextRound"
let SEGUE_DECLARE_VERDICT = "DeclareVerdict"
let SEGUE_NEW_GAME_FROM_VERDICTVC = "StartNewGame"
let SEGUE_GO_TO_GRAVEYARD = "GoToGraveyard"
let SEGUE_VERDICT_FOR_GHOST = "GiveVerdictForGhost"

let CUSTOM_CELL = "CustomTableViewCell"
let THIS_ROUND_CELL = "ThisRoundCell"

/* Error Messages */

let ERR_SCREENNAME_MISSING_TITLE = "Screen Name Missing"
let ERR_SCREENNAME_MISSIN_MSG = "You need to put on your bluffing name"
let ERR_GAMECODE_MISSING_TITLE = "Game Code Missing"
let ERR_GAMECODE_MISSING_MSG = "Bully the game leader until they give you the code"
let ERR_WRONG_CODE_TITLE = "Incorrect Gamecode"
let ERR_WRONG_CODE_MSG = "Are you sure you are sober?"
let ERR_JOIN_GAME_TITLE = "Error Joining Game"
let ERR_JOIN_GAME_MSG = "Please try again later. Could not join the room with code"
let ERR_NEED_PLAYERS_TITLE = "Patience!"
let ERR_NEED_PLAYERS_MSG = "Need \(MIN_PLAYERS) or more players to enjoy bluffin'"
let ERR_SELF_VOTE_TITLE = "Self Vote!"
let ERR_SELF_VOTE_MSG = "Suicide is a crime"
let ERR_VOTE_ABSENT_TITLE = "Vote Missing!"
let ERR_VOTE_ABSENT_MSG = "Need to select a player to vote out"
let ERR_VOTE_FAILED_TITLE = "Vote Failed :("
let ERR_VOTE_FAILED_MSG = "Could not cast your vote. Please check your network connection and try again"

let ALERT_BEGIN_VOTING_TITLE = "Discuss and Vote"
let ALERT_BEGIN_VOTING_MSG = "There's Penalty for voting against an innocent player"
let ALERT_LEAVE_GAME_TITLE = "Are You Sure? :("
let ALERT_LEAVE_GAME_TITLE2 = "Leave Game? :("
let ALERT_START_NEW_GAME = "Start a New Game?"


/* Statuses */

let BUSY_CREATING_GAME = "Creating Game..."
let BUSY_SAVING_SCORE = "Saving Score..."
let BUSY_DECIDING_WINNER = "Deciding Winner..."

let STATUS_ENTER_SCREENNAME = "Don a Screen Name"
let STATUS_CHANGE_SCREENNAME = "Change your Screen Name"
let STATUS_WAITING_TO_START = "Waiting for Captain to start the game..."
let STATUS_NEED_MORE_PLAYERS = "Waiting for more players to join..."
let STATUS_START_GAME = "Begin the Bluff Marathon"
let STATUS_INNOCENT_MSG = "You're Innocent. Be Alert"
let STATUS_BLUFFMATR_MSG = "You're the BluffMastr. Answers are sorted scorewise: LOW to HIGH"
let STATUS_SCORE_LESS_THAN_3 = "Not Bad."
let STATUS_SCORE_3_TO_7 = "Good Job."
let STATUS_SCORE_MORE_THAN_7 = "Great Going."
let STATUS_WAITING_ALL_ANSWERS = "Waitin for everyone to answer..."
let STATUS_LAST_ROUND_SCORES = "Scores for this round"
let STATUS_VOTE_RESULT_PLACEHOLDER = "has been voted out and..."
let STATUS_TIE = "Snap, it's a tie. Need to revote"
let STATUS_INNOCENT_PLAYER = "is an INNOCENT player"
let STATUS_BLUFFMASTR_FOUND = "is the BLUFFMASTR"
let STATUS_CUMULATIVE_SCORES = "Cumulative Scores"
let STATUS_START_VOTING = "Select a Player to Voteout"
let STATUS_YOU_ARE_OUT = "Uh oh. You have been voted out"
let STATUS_WAITING_OTHERS_NXT_ROUND = "Waiting for others..."
let STATUS_STARTING_NEXT_ROUND = "Starting next round..."
let STATUS_COMPUTING_BONUS = "Computing Bonuses and Penalties per round ..."

let TIP_GAME_PHILOSOPHY = "Select the least probable answer for most points"
let TIP_START_VOTEOUT = "Discuss. When ready, begin voting and select a player to voteout"

let VOTES = "Votes"

/* Help Titles and Messages */

let HELP_QUESTIONVC_TITLE = "Collect Points.."
let HELP_QUESTIONVC_BODY = " ◦ Every Question has 10 answers\n ◦ Most common answer has the least points and the least common answer has the most points\n ◦ The BluffMastr has the answers sorted in the increasing order of points \n◦ Innocent players have their answers shuffled\n\n\n ✩ Remember - There is a voteout after every round\n ✩ Goal: Score as many points as you can whilst staying alive"

/* Codes */

let CODE_TIE = "TIE"

/* Comments */

let CMT_GAME_PREP = "Hold your breath. You could be the next BluffMastr!"

/* Service Constants */

let SVC_GAME_CAPTAIN = "gameCaptain"
let SVC_GAME_BLUFFMASTER = "gameBluffMaster"
let SVC_PROVIDER = "provider"
let SVC_SCREEN_NAME = "screenName"
let SVC_SHARED_TOKEN = "sharedToken"
let SVC_GAME_DICT = "genericGameDict"
let SVC_CURRENT_QUESTION = "currentQuestion"
let SVC_QUESTION_TITLE = "title"
let SVC_GAME_ROUND = "round"