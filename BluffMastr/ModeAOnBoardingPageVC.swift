//
//  ModeAOnBoardingViewController.swift
//  Bluffathon
//
//  Created by Srikant Viswanath on 7/27/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class ModeAOnboardingPageVC: UIPageViewController, UIPageViewControllerDataSource {

    lazy var orderedVCs: [UIViewController] = {
        return [self.newOnboardingVC("OverviewOnboarding"),
                self.newOnboardingVC("QuestionVCOnboarding"),
                self.newOnboardingVC("discussOnboarding"),
                self.newOnboardingVC("voteoutOnboarding"),
                self.newOnboardingVC("conclusionOnboarding")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let onboardingHelpVC = orderedVCs.first {
            setViewControllers([onboardingHelpVC], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func newOnboardingVC(storyboardId: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardId)
    }
    
    //MARK: UIPageVC DataSource Delegate Methods
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedVCs.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = orderedVCs.first, firstViewControllerIndex = orderedVCs.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVCs.indexOf(viewController) else {
            return nil
        }
        
        let prevIndex = vcIndex - 1
        if (prevIndex >= 0 && orderedVCs.count > prevIndex) {
            return orderedVCs[prevIndex]
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVCs.indexOf(viewController) else {
            return nil
        }
        
        let nextVCIndex = vcIndex + 1
        if nextVCIndex < orderedVCs.count {
            return orderedVCs[nextVCIndex]
        } else {
            return nil
        }
    }
    
    
}