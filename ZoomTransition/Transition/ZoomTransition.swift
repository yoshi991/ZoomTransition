//
//  ZoomTransition.swift
//  ZoomTransition
//
//  Created by Henmi Yoshiki on 2019/07/05.
//  Copyright © 2019 yoshi991. All rights reserved.
//

import UIKit

class ZoomTransition: NSObject {
    
    class var sharedInstance: ZoomTransition {
        struct shared {
            static let instance: ZoomTransition = ZoomTransition()
        }
        return shared.instance
    }
    
    fileprivate var isPresent = false
    
    private func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    private func dissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
            return
        }
    }
}

extension ZoomTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = false
        return self
    }
}

extension ZoomTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.isPresent {
            return 0.3
        }
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isPresent {
            self.presentTransition(transitionContext: transitionContext)
        } else {
            self.dissmissalTransition(transitionContext: transitionContext)
        }
    }
}
