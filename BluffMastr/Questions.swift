//
//  Questions.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/10/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class Questions {
    
    static var questions = Questions()
    static var completedQuestionIds = [Int]()
    
    ///Pick up the currentQuestionId from games and get the title from questions/questionId
    func listenForNextQuestion(completed: GenericCompletionBlock) {
        Games.games.fetchGameSnapshot {
            FDataService.fDataService.REF_QUESTIONS.child("\(Games.currentQuestionId!)").observeSingleEventOfType(.Value, withBlock: { qSnapShot in
                if let questionTitle = qSnapShot.value![SVC_QUESTION_TITLE] as? String {
                    Games.currentQuestionTitle = questionTitle
                    completed()
                }
            })
        }
    }
    
    func fetchAnswerList(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_ANSWERS.child("\(Games.currentQuestionId!)").observeSingleEventOfType(.Value, withBlock: { answersSS in
                for child in (answersSS.children.allObjects as? [FIRDataSnapshot])! {
                    Games.answersDict[child.key] = child.value as? String
                }
            completed()
            }
        )
    }
    
    func fetchMaxNumberOfQuestions(completed: GenericCompletionBlock) {
        FDataService.fDataService.REF_BASE.child("NumberOfQuestions").observeSingleEventOfType(.Value, withBlock: { maxQuestionsSS in
            TOTAL_QUESTIONS_AT_FIREBASE = maxQuestionsSS.value as! Int
            completed()
        })
    }
}