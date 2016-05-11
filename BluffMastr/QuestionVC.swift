//
//  QuestionVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/8/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {

    @IBOutlet weak var questionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Questions.questions.listenForNextQuestion{
            self.questionLbl.text = Games.currentQuestionTitle
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if Games.bluffMastr == Users.myScreenName {
            showErrorMsg(STATUS_BLUFFMATR_TITLE, msg: STATUS_BLUFFMATR_MSG)
        } else {
            showErrorMsg(STATUS_INNOCENT_TITLE, msg: STATUS_INNOCENT_MSG)
        }
    }

    func showErrorMsg(title: String!, msg: String!){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func cheat(sender: UITapGestureRecognizer) {
        
    }
}
