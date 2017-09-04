//
//  SFNavigationController.swift
//  testCarousel
//
//  Created by romiroma on 8/30/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    private lazy var animationController: SFCarouselDetailAnimationController! = SFCarouselDetailAnimationController()

    private var isInteractive = false
    private var swipeFromLeftGestureRecognizer: UIScreenEdgePanGestureRecognizer!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self

        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true

        view.backgroundColor = UIColor.white

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()

        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        swipeFromLeftGestureRecognizer = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(handleScreenEdgePan))
        swipeFromLeftGestureRecognizer.edges = .left
        view.addGestureRecognizer(swipeFromLeftGestureRecognizer)
    }

    func handleScreenEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        let translate = recognizer.translation(in: recognizer.view)
        guard let viewWidth = recognizer.view?.bounds.size.width else {
            return
        }
        let percent = translate.x / viewWidth

        switch recognizer.state {
        case .began:
            isInteractive = true
            popViewController(animated: true)
        case .changed:
            animationController.update(percent)
        case .ended:
            let velocity = recognizer.velocity(in: recognizer.view)
            if percent > 0.5 || velocity.x > 0 {
                animationController.finish()
            } else {
                animationController.cancel()
            }
            self.isInteractive = false
        default: break
        }
    }

    // MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .push || operation == .pop {
            animationController.isInteractive = false
            return animationController
        }

        return nil
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        guard let sfAnimationController = animationController as? SFCarouselDetailAnimationController else {
            return nil
        }
        sfAnimationController.isInteractive = isInteractive
        return isInteractive ? sfAnimationController : nil
    }

    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }



}
