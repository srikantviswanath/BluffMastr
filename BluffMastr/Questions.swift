//
//  Questions.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/10/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation


class Questions {
    
    static var totalQuestionsAtFB: Int!
    static var questions = Questions()
    
    /* Pick up the currentQuestionId from games and get the title from questions/questionId */
    func listenForNextQuestion(completed: GenericCompletionBlock) {
        Games.games.listenToGameChanges(SVC_CURRENT_QUESTION) {
            FDataService.fDataService.REF_QUESTIONS.childByAppendingPath("\(Games.currentQuestionId)").observeEventType(.Value, withBlock: { qSnapShot in
                if let questionTitle = qSnapShot.value as? String {
                    Games.currentQuestionTitle = questionTitle
                    completed()
                }
            })
        }
    }
}