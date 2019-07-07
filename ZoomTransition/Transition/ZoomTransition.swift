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
        let containerView = transitionContext.containerView
        
        guard
            let sourceVC = transitionContext.viewController(forKey: .from) as? SourceViewController,
            let destinationVC = transitionContext.viewController(forKey: .to) as? DestinationViewController,
            let cell = sourceVC.collectionView?.cellForItem(at: (sourceVC.collectionView?.indexPathsForSelectedItems?.first)!) as? CollectionViewCell
            else {
                return
        }
        
        let animationView = UIImageView(image: cell.imageView.image)
        animationView.frame = containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
        self.setImageFilter(imageView: animationView)
        
        cell.imageView.isHidden = true
        
        destinationVC.view.frame = transitionContext.finalFrame(for: destinationVC)
        destinationVC.view.alpha = 0
        destinationVC.imageView.isHidden = true
        
        containerView.addSubview(destinationVC.view)
        containerView.addSubview(animationView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destinationVC.view.alpha = 1.0
            animationView.frame = containerView.convert(destinationVC.imageView.frame, from: destinationVC.view)
        }, completion: { _ in
            cell.imageView.isHidden = false
            destinationVC.imageView.isHidden = false
            animationView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    private func dissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard
            let sourceVC = transitionContext.viewController(forKey: .to) as? SourceViewController,
            let destinationVC = transitionContext.viewController(forKey: .from) as? DestinationViewController,
            let cell = sourceVC.collectionView?.cellForItem(at: destinationVC.indexPath) as? CollectionViewCell
            else {
                return
        }

        let animationView = destinationVC.imageView.snapshotView(afterScreenUpdates: false)
        animationView?.frame = containerView.convert(destinationVC.imageView.frame, from: destinationVC.imageView.superview)
        destinationVC.imageView.isHidden = true
        
        cell.imageView.isHidden = true
        
        sourceVC.view.frame = transitionContext.finalFrame(for: sourceVC)
        containerView.addSubview(animationView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destinationVC.view.alpha = 0
            animationView?.frame = containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
        }, completion: { _ in
            animationView?.removeFromSuperview()
            destinationVC.imageView.isHidden = false
            cell.imageView.isHidden = false
            transitionContext.completeTransition(true)
        })
    }
    
    private func setImageFilter(imageView: UIImageView){
        guard let cgImage = imageView.image?.cgImage else {
            return
        }
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIBoxBlur")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        if let filterImage = filter.outputImage {
            imageView.image = UIImage(ciImage: filterImage)
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
            return 1.3
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
