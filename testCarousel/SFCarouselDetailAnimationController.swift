//
//  SFCarouselDetailAnimationController.swift
//  testCarousel
//
//  Created by romiroma on 8/28/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselDetailAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC1 = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        

        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SFCarouselTransitionViewProvider,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SFCarouselTransitionViewProvider,
            let finalFrame = toVC.absoulteFrameForTransitionView,
            let startFrame = fromVC.absoulteFrameForTransitionView else {
                return
        }

        (fromVC as? UIViewController)?.beginAppearanceTransition(false, animated: true)

        let containerView = transitionContext.containerView


        let fromView = fromVC.viewForTransition
        let snapshot = fromView?.snapshotView(afterScreenUpdates: true)


        guard snapshot != nil else {
            return
        }

        snapshot!.frame = startFrame

        toVC.view.isHidden = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/6, animations: {
                    fromView?.alpha = 0
                })
                UIView.addKeyframe(withRelativeStartTime: 1/6, relativeDuration: 1/6, animations: {
                    snapshot!.frame.size = finalFrame.size
                })
                UIView.addKeyframe(withRelativeStartTime: 2/6, relativeDuration: 4/6, animations: {
                    snapshot!.frame.origin = finalFrame.origin
                })

        },
            completion: { _ in
                toVC.view.isHidden = false
                snapshot!.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromView?.alpha = 1
        })

    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    
}
