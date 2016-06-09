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

