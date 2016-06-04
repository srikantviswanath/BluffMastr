//
//  VoteResultVC.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/25/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class VoteResultVC: UIViewController {

    @IBOutlet weak var waitingForAllVotesSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitingForAllVotesSpinner.startAnimating()
    }
}
