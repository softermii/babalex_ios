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
    weak var controller: SFDatasource?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self

        setupBackground()
        setupNavigationBarAppearance()
        setupGestureRecognizers()

        edgesForExtendedLayout = UIRectEdge.top
    }

    private func setupBackground() {
        view.layer.contents = UIImage(named: "dirty_background")?.cgImage
    }

    private func setupNavigationBarAppearance() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.black
    }

    private func setupGestureRecognizers() {
        interactivePopGestureRecognizer?.isEnabled = false

        swipeFromLeftGestureRecognizer = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(handleScreenEdgePan))
        
        swipeFromLeftGestureRecognizer.delegate = self
        swipeFromLeftGestureRecognizer.edges = .left
        swipeFromLeftGestureRecognizer.delaysTouchesBegan = false
        swipeFromLeftGestureRecognizer.delaysTouchesEnded = false
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

            isInteractive = false
        default: break
        }
    }

    // MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

//        print("toVC", toVC as? SFCarouselTransitionViewProvider)

        if (operation == .push || operation == .pop) && (toVC as? SFCarouselTransitionViewProvider != nil && fromVC as? SFCarouselTransitionViewProvider != nil) {
            animationController.isInteractive = false
            return animationController
        }



        return nil
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        guard let sfAnimationController = animationController as? SFCarouselDetailAnimationController,
            isInteractive else {
            return nil
        }
        sfAnimationController.isInteractive = isInteractive
        return sfAnimationController
    }

    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gR = gestureRecognizer as? UIScreenEdgePanGestureRecognizer else {
            return false
        }

        let locationY = gR.location(in: view).y
        return locationY < view.bounds.size.height - 60
    }

}
