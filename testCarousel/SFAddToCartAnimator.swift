//
//  SFAddToCartAnimator.swift
//  testCarousel
//
//  Created by romiroma on 9/7/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFAddToCartAnimator: NSObject, CAAnimationDelegate {

    static let instance = SFAddToCartAnimator()
    static var animationNumber = 0
    let duration: CFTimeInterval = 0.3

    private var snapshots: [Int: UIView] = [:]
    private var completions: [() -> ()] = []

    func animateAddingItem(from: UIView?, to: UIBarButtonItem?, completion: @escaping () -> ()) {
        guard let window = from?.window,
            let toView = to?.value(forKey: "view") as? UIView else {
                debugPrint("Important! window cannot we nil! check from view you want to animate")
                return
        }

        guard let snapshot = from!.snapshotView(afterScreenUpdates: false) else {
            debugPrint("Important! Can't create snapsot of starting view")
            return
        }

        let fromFrame = from!.superview!.convert(from!.frame, to: window)
        let convertedFrame = toView.superview!.convert(toView.frame, to: window)
        let multiplier = convertedFrame.size.width / fromFrame.size.width

        snapshot.frame = fromFrame
        window.addSubview(snapshot)

        let positionAnimation = CAKeyframeAnimation(keyPath: "position")


        // Animation's path
        let path = UIBezierPath()

        let fromPosition = CGPoint(x: fromFrame.origin.x + fromFrame.size.width / 2, y: fromFrame.origin.y + fromFrame.size.height / 2)

        let toPosition = CGPoint(x: convertedFrame.origin.x + convertedFrame.size.width / 2, y: convertedFrame.origin.y + convertedFrame.size.height / 2)

        path.move(to: fromPosition)

        // Calculate the control points
        let c1 = CGPoint(x: fromPosition.x + 64, y: fromFrame.origin.y)
        let c2 = CGPoint(x: toPosition.x,        y: toPosition.y - 128)

        path.addCurve(to: toPosition, controlPoint1: c1, controlPoint2: c2)

        positionAnimation.path = path.cgPath

        positionAnimation.fillMode              = kCAFillModeForwards
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.duration              = duration
        positionAnimation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)

        let sizeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        sizeAnimation.fillMode              = kCAFillModeForwards
        sizeAnimation.values = [1, multiplier]
        sizeAnimation.isRemovedOnCompletion = false
        sizeAnimation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        sizeAnimation.duration = duration

        let alphaAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        alphaAnimation.fillMode              = kCAFillModeForwards
        alphaAnimation.duration = duration + 0.1
        alphaAnimation.delegate = self


        completions.append(completion)
        alphaAnimation.setValue(type(of: self).animationNumber, forKey: "number")
        snapshots[type(of: self).animationNumber] = snapshot
        type(of: self).animationNumber += 1

        snapshot.layer.add(positionAnimation, forKey: "position")
        snapshot.layer.add(sizeAnimation, forKey: "size")
        snapshot.layer.add(alphaAnimation, forKey: "alpha")


    }

    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        guard let anim = animation as? CABasicAnimation,
            let number = anim.value(forKey: "number") as? Int else {
            return
        }

        snapshots[number]?.removeFromSuperview()

        let completion = completions.removeFirst()
        completion()
    }
}
