//
//  SFNavigationController.swift
//  testCarousel
//
//  Created by romiroma on 8/30/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFNavigationController: UINavigationController, UINavigationControllerDelegate {

    private lazy var animationController: SFCarouselDetailAnimationController! = SFCarouselDetailAnimationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.view.backgroundColor = UIColor.white
//
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.isTranslucent = true
//        self.navigationBar.backgroundColor = UIColor.clear

    }

    // MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }

}
