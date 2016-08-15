//
//  PopUpBubble.swift
//  Bluffathon
//
//  Created by Srikant Viswanath on 8/14/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class PopUpBubble {
    
    var content: String!
    var anchorPointRect: CGRect
    var anchorDirection: UIPopoverArrowDirection
    
    init(tipContent: String, anchorPointRect: CGRect, anchorDirection: UIPopoverArrowDirection = .Any) {
        
        self.content = tipContent
        self.anchorPointRect = anchorPointRect
        self.anchorDirection = anchorDirection
    }
}