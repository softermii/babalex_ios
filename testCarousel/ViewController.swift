//
//  ViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    var carouselController: SFCarouselController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        prepareCarouselView()
    }

    private func prepareCarouselView() {
        carouselController = SFCarouselController()
        carouselController.prepareDummyCarouselItems()


        carouselController.embedInViewController(self, view: self.view)

    }
}

