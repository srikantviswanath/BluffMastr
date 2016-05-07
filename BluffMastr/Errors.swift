//
//  Errors.swift
//  BluffMastr
//
//  Created by Nitin Jami on 5/7/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ErrorHandler: UIViewController {
    
    static var errorHandler = ErrorHandler()
    
    func showErrorMsg(title: String!, msg: String!){
        //Bug: view hierarchy bug.
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
