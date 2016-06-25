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
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        UIApplication.topViewController()!.presentViewController(alert, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}