//
//  ViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, SFCarouselTransitionViewProvider {

    var carouselController: SFCarouselController!
    var viewForTransition: UIView? {
        get {
            return carouselController?.selectedViewForTransitioning
        }
    }
    var absoulteFrameForTransitionView: CGRect? {
        get {
            if let v = viewForTransition {
//                var vFrame = v.frame
                return v.convert(v.frame, to: self.view)
//                (v.frame, to: self.view)
            }

            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCarouselView()
        prepareNavigationBarItems()
    }

    private func prepareCarouselView() {
        carouselController = SFCarouselController()
        carouselController.prepareDummyCarouselItems()
        carouselController.embedInViewController(self, view: self.view)
    }

    private func prepareNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shopping-basket"), style: .plain, target: self, action: nil)
    }
}

