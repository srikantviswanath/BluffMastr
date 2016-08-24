//
//  GameplayUtils.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/13/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import GameplayKit

func isPlayerBluffMastr() -> Bool{
    return Games.bluffMastr == Users.myScreenName
}

///Evaluate the answer submitted by player. If answer not present(Typo?), return 0
func evaluateScore(answerSubmitted: String) -> String{
    for (score, value) in Games.answersDict {
        if value == answerSubmitted {
            return score
        }
    }
    return "0"
}

///Fetch a player's score from the leaderboard
func fetchPlayerScoreFromLeaderboard(player: String) -> Int {
    for voterDict in Games.leaderboard {
        if Array(voterDict.keys)[0] == player {
            return Array(voterDict.values)[0]
        }
    }
    return 999
}

func getScorePhrase(playerScore: Int) -> String {
    if playerScore <= 3 {
        return STATUS_SCORE_LESS_THAN_3
    } else if (playerScore > 3 && playerScore < 7) {
        return STATUS_SCORE_3_TO_7
    } else {
        return STATUS_SCORE_MORE_THAN_7
    }
}


func shuffleArray(arrayOfInt: [Int]) -> [Int] {
    return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(arrayOfInt) as! [Int]
}

func randomFourDigitString() -> String {
    return String(GKRandomSource.sharedRandom().nextIntWithUpperBound(8999) + 1000)
}

func randomIntTypeString() -> String {
    return String(GKRandomSource.sharedRandom().nextIntWithUpperBound(100))
}

///Method to return a dict with the # of votes against each player
func countVotes() -> Dictionary<String, Int> {
    var voteCounter = Dictionary<String, Int>()
    for (_, voteCasted) in Games.votesCastedForThisRound {
        if voteCounter[voteCasted] != nil {
            voteCounter[voteCasted]! += 1
        } else {
            voteCounter[voteCasted] = 1
        }
    }
    return voteCounter
}

/** Method to evaluate the right person to eliminate based on current round's votes
    - In case of a tie, return CODE_TIE, so that revoting is conducted again
 */
func evaluateVotes() -> String {
    let sortedVotes = (countVotes() as NSDictionary).keysSortedByValueUsingSelector(#selector(NSNumber.compare(_:)))
    if sortedVotes.count > 1 {
        let topperScore = countVotes()[sortedVotes.reverse()[0] as! String]!
        let nextHighest = countVotes()[sortedVotes.reverse()[1] as! String]!
        if  topperScore == nextHighest {return CODE_TIE}
        else {return sortedVotes.reverse()[0] as! String}
            
    } else { //Bumper unanimous majority
        return sortedVotes.reverse()[0] as! String
    }
}

/** Method to remove a player from local cache of GameMembers.playersInGameRoom upon the :player: voteout
    - If Games.BluffMastr has been voted out in the previous round, reset local copy to nil
*/

func removePlayerFromRoomCache(player: String) {
    GameMembers.playersInGameRoom = GameMembers.playersInGameRoom.filter { $0 != player}
}

/** Method to randomize next question's Id and BluffMaster when applicable for the next round
  :returns: a dictionary that should be updated in Firebase at /Games
 */
func randomizeNextRoundData()  -> Dictionary<String, String>{
    var nextRoundDict = Dictionary<String, String>()
    var nextQuestionId = Int(arc4random_uniform(UInt32(TOTAL_QUESTIONS_AT_FIREBASE)))
    if Games.bluffMastr == nil { //Before first round or in a subsequent round when previous BluffMastr has been voted out
        let randomPlayerNum = Int(arc4random_uniform(UInt32(GameMembers.playersInGameRoom.count)))
        let bluffmastr = GameMembers.playersInGameRoom[randomPlayerNum]
        Games.bluffMastr = bluffmastr
        nextRoundDict[SVC_GAME_BLUFFMASTER] = bluffmastr
    }
    if Games.currentQuestionId == nil { // About to start first round
        nextRoundDict[SVC_CURRENT_QUESTION] = "\(nextQuestionId)"
        nextRoundDict[SVC_GAME_ROUND] = "\(1)"
    } else { //Previous BluffMastr survives and about to start another round
        while Questions.completedQuestionIds.contains(nextQuestionId) {
            nextQuestionId = Int(arc4random_uniform(UInt32(TOTAL_QUESTIONS_AT_FIREBASE)))
        }
        nextRoundDict[SVC_CURRENT_QUESTION] = "\(nextQuestionId)"
    }
    
    return nextRoundDict
}

///Method to evaluate bonus or penalty based on Users.myBonusHistory
func evaluateBonusOrPenaltyPerRound() -> Int {
    if Users.myScreenName == Games.bluffMastr {
      return BONUS_BLUFFMASTR_SURVIVAL
    }
    if Users.mycurrentVote == Games.bluffMastr {
        return BONUS_VOTED_AGAINST_BLUFFMASTR
    } else {
        return PENALTY_VOTED_AGAINST_INNOCENT_PLAYER
    }
    
}

func resetStaticVariablesForNewGame() {
    Games.gameUID = nil
    Games.bluffMastr = nil
    Games.sharedToken = nil
    Games.gameCreator = nil
    Games.roundNumber = nil
    Games.currentQuestionTitle = nil
    Games.currentQuestionId = nil
    Games.answersDict = Dictionary<String, String>()
    Games.playersSubmissions = [Dictionary<String, Int>]()
    Games.leaderboard = [Dictionary<String, Int>]()
    Games.finalScores = [Dictionary<String,Int>]()
    Games.votesCastedForThisRound = Dictionary<String, String>()
    Games.playersReadyForNextRound = [String]()
    Games.listenGameFBHandle = nil
    GameMembers.originalPlayersAtGameStart = [String]()
    GameMembers.playersInGameRoom = [String]()
    GameMembers.votedoutPlayers = [String]()
    Users.myCurrentAnswer = nil
    Users.mycurrentVote = nil
    Users.myBonusHistory = [Dictionary<String, Int>]()
    Questions.completedQuestionIds = [Int]()

}

func removeAllListeners() {
    FDataService.fDataService.REF_GAMES.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_GAME_MEMBERS.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_QUESTIONS.removeAllObservers()
    FDataService.fDataService.REF_ANSWERS.removeAllObservers()
    FDataService.fDataService.REF_CURRENT_ROUNDS.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_LEADERBOARDS.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_VOTES.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_READY_NEXT.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_GHOST_PLAYERS.child(Games.gameUID).removeAllObservers()
    FDataService.fDataService.REF_FINAL_SCORES.child(Games.gameUID).removeAllObservers()
}



func teardownAfterStartingGame() {
    Users.users.deleteAnonymousUser()
    GameMembers.gameMembers.removePlayerFromRoom(Users.myScreenName)
    GameMembers.gameMembers.removeGameMemberListeners()
}
 