//
//  AnimationEngine.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 6/22/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import pop

class AnimationEngine {
    
    let ANIM_DELAY = 0.8
    
    class var offScreenRightPosition: CGPoint {
        return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    var originalConstants = [CGFloat]()
    var constraints = [NSLayoutConstraint]()
    
    ///Initializer for elements that are bound by a leading and a trailing constraint
    init(leadingConstraint: NSLayoutConstraint, trailingConstraint: NSLayoutConstraint) {
        let origLeadingConst = leadingConstraint.constant
        let origTrailingConst = trailingConstraint.constant
        
        originalConstants.append(origLeadingConst)
        originalConstants.append(origTrailingConst)
        
        leadingConstraint.constant = AnimationEngine.offScreenRightPosition.x
        self.constraints.append(leadingConstraint)
        
        trailingConstraint.constant = origTrailingConst - (leadingConstraint.constant - origLeadingConst)
        self.constraints.append(trailingConstraint)
    }
    
    ///Initializer for elements with a horizontal center contraint
    init(constraints: [NSLayoutConstraint]) {
        for con in constraints {
            originalConstants.append(con.constant)
            con.constant = AnimationEngine.offScreenRightPosition.x
        }
        self.constraints = constraints
    }
    
    func animateOnScreen(friction:Int = 0, delay:Double? = nil) {
        let timedDelay = dispatch_time(DISPATCH_TIME_NOW, Int64((delay == nil ? ANIM_DELAY:delay!) * Double(NSEC_PER_SEC)))
        dispatch_after(timedDelay, dispatch_get_main_queue()) {
            for constIdx in 0...self.constraints.count-1 {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.originalConstants[constIdx]
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                moveAnim.dynamicsFriction = CGFloat(friction)
                self.constraints[constIdx].pop_addAnimation(moveAnim, forKey: "intialSpin")
            }
        }
    }
}