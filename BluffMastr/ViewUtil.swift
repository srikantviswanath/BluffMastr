//
//  ViewUtil.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/16/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import UIKit



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class AlertHandler: UIViewController {
    
    static var alert = AlertHandler()
    
    func showAlertMsg(title: String, msg: String, actionBtnTitle: String = "OK") {
        let parentVC = UIApplication.topViewController()!
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = parentVC.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alertVC = storyboard.instantiateViewControllerWithIdentifier("alertVC") as! AlertVC
        alertVC.view.backgroundColor = UIColor.clearColor()
        alertVC.AlertTitle!.text = title
        alertVC.AlertMsg!.text = msg
        alertVC.ActionBtn!.setTitle(actionBtnTitle, forState: .Normal)
        alertVC.parentBlurView = blurEffectView
        alertVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        alertVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        parentVC.view.addSubview(blurEffectView)
        parentVC.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func showWelcomeModal(landingVCSelf: LandingVC) {
        let parentVC = UIApplication.topViewController()!
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.mainScreen().bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("welcomeVC") as! WelcomeVC
        
        welcomeVC.view.backgroundColor = UIColor.clearColor()
        welcomeVC.parentBlurView = blurEffectView
        welcomeVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        welcomeVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        welcomeVC.delegate = landingVCSelf
        parentVC.view.addSubview(blurEffectView)
        parentVC.presentViewController(welcomeVC, animated: true, completion: nil)

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

func showBusyModal(busyText: String) -> UIView {
    let parentVCView = UIApplication.topViewController()?.view
    let busyModalFrame = UIView(frame: CGRect(x: parentVCView!.frame.midX - 90, y: parentVCView!.frame.midY - 25 , width: 200, height: 100))
    let busySpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    let busyLbl = UILabel(frame: CGRect(x: 50, y: 25, width: 200, height: 50))
    
    parentVCView?.alpha = 0.8
    busyLbl.text = busyText
    busyLbl.textColor = UIColor.whiteColor()
    
    busyModalFrame.layer.cornerRadius = 15
    busyModalFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
    
    busySpinner.frame = CGRect(x: 0, y: 25, width: 50, height: 50)
    busySpinner.startAnimating()
    
    busyModalFrame.addSubview(busySpinner)
    busyModalFrame.addSubview(busyLbl)
    parentVCView!.addSubview(busyModalFrame)
    
    return busyModalFrame
}
