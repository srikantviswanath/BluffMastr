//
//  ViewController.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createGame(sender: UIButton!){
        /* 1. Create a game session in Firebase
           2. Create an anonymous user session for the master
           3. Display the gameTokenId for the game in StagingVC
           4. SHow the masterUser as the first player in the room
         */
        print("Something Fishy!!")
        performSegueWithIdentifier(SEGUE_LANDING_STAGING, sender: nil)
    }
    
    @IBAction func joinGame(sender: UIButton!){
        /* 1. Enter a gameTokenId and submit
           2. If successful add the slaveUser to the list of currentPlayers in the room
         */

        performSegueWithIdentifier(SEGUE_LANDING_STAGING, sender: nil)
    }



}

