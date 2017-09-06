//
//  SFCarouselDetailAnimationController.swift
//  testCarousel
//
//  Created by romiroma on 8/28/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselDetailAnimationController: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

    private weak var fromVC: SFCarouselTransitionViewProvider? = nil
    private weak var toVC: SFCarouselTransitionViewProvider? = nil

    private weak var fromView: UIView? = nil
    private weak var toView: UIView? = nil

    private var snapshot: UIView? = nil

    private var startFrame: CGRect? = nil
    private var finalFrame: CGRect? = nil

    private weak var transitionContext: UIViewControllerContextTransitioning? = nil

    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)

        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SFCarouselTransitionViewProvider,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SFCarouselTransitionViewProvider,
            let finalFrame = toVC.absoulteFrameForTransitionView,

            let startFrame = fromVC.absoulteFrameForTransitionView else {
                return
        }

        self.fromVC = fromVC
        self.toVC = toVC

        self.startFrame = startFrame
        self.finalFrame = finalFrame

        self.transitionContext = transitionContext

        (fromVC as? UIViewController)?.beginAppearanceTransition(false, animated: false)

        let containerView = transitionContext.containerView

        fromView = fromVC.viewForTransition
        toView = toVC.viewForTransition
        snapshot = fromView?.snapshotView(afterScreenUpdates: false)

        guard snapshot != nil else {
            return
        }

        snapshot!.frame = startFrame

        fromView?.alpha = 0
        toVC.view.alpha = 0
        toView?.alpha = 0

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)

        fromView?.alpha = 0

    }

    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)

        toVC?.view.alpha = percentComplete

        guard startFrame != nil, finalFrame != nil, snapshot != nil else {
            return
        }

        
        let startSize = startFrame!.size
        let finalSize = finalFrame!.size
        let width = startSize.width + percentComplete * (finalSize.width - startSize.width)
        let height = startSize.height + percentComplete * (finalSize.height - startSize.height)

        snapshot?.frame.size = CGSize(width: width, height: height)

        let startOrigin = startFrame!.origin
        let finalOrigin = finalFrame!.origin

        let currentX = startOrigin.x + percentComplete * (finalOrigin.x - startOrigin.x)
        let currentY = startOrigin.y + percentComplete * (finalOrigin.y - startOrigin.y)

        snapshot?.frame.origin = CGPoint(x: currentX, y: currentY)

    }

    override func finish() {
        super.finish()

        guard snapshot != nil, finalFrame != nil else {
            return
        }

        UIView.animate(withDuration: 0.1, animations: {
            self.toVC?.view.alpha = 1
            self.fromView?.alpha = 1
            self.snapshot!.frame = self.finalFrame!

        }) { (isFinished: Bool) in

            self.toView?.alpha = 1
            self.toView?.isHidden = false
            self.fromView?.isHidden = false
            self.snapshot!.removeFromSuperview()
        }

        guard transitionContext != nil else {
            return
        }

        transitionContext!.completeTransition(!transitionContext!.transitionWasCancelled)

    }

    override func cancel() {
        super.cancel()

        self.toView?.alpha = 1
        self.toView?.isHidden = false
        self.fromView?.alpha = 1
        self.snapshot?.removeFromSuperview()
        self.toVC?.view?.removeFromSuperview()

        (self.toVC as? UIViewController)?.endAppearanceTransition()

        transitionContext?.completeTransition(false)
    }


    public var isInteractive = false

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard !isInteractive, let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SFCarouselTransitionViewProvider,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SFCarouselTransitionViewProvider,
            let finalFrame = toVC.absoulteFrameForTransitionView,

            let startFrame = fromVC.absoulteFrameForTransitionView else {
                return
        }

        (fromVC as? UIViewController)?.beginAppearanceTransition(false, animated: true)

        let containerView = transitionContext.containerView

        let fromView = fromVC.viewForTransition
        let toView = toVC.viewForTransition
        let snapshot = fromView?.snapshotView(afterScreenUpdates: true)


        guard snapshot != nil else {
            return
        }

        snapshot!.frame = startFrame
        toVC.view.alpha = 0
        toView?.isHidden = true

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
                    fromVC.view.alpha = 0.85
                })
                UIView.addKeyframe(withRelativeStartTime: 1/6, relativeDuration: 5/6, animations: {
                    snapshot!.frame.size = finalFrame.size
                    snapshot!.frame.origin = finalFrame.origin
                    fromVC.view.alpha = 0
                })
                UIView.addKeyframe(withRelativeStartTime: 4/6, relativeDuration: 2/6, animations: {

                    toVC.view.alpha = 1
                })

        },
            completion: { _ in
                snapshot!.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromView?.alpha = 1
                fromVC.view.alpha = 1
                toView?.isHidden = false

        })

    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    
}
