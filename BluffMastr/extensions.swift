//
//  extensions.swift
//  Bluffathon
//
//  Created by Nitin Jami on 8/3/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import UIKit

// https://github.com/goktugyil/EZSwiftExtensions#uiviewcontroller-extensions
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}