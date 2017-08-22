//
//  SFCarouselVerticalPageViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCarouselVerticalPageViewController: UIPageViewController, UIScrollViewDelegate {

    init(_ controller: SFCarouselControllerProtocol?, firstViewController: UIViewController) {
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        self.view.tag = 0
        
        self.delegate = controller
        self.dataSource = controller

        self.setViewControllers([firstViewController], direction: .forward, animated: true) { (isSet: Bool) in
            print("setViewControllers")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.subviews.forEach { (subView: UIView) in
            (subView as? UIScrollView)?.delegate = self
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let percentComplete = fabs(point.y - view.frame.size.height)/view.frame.size.height
        print("vertical percentComplete:", percentComplete)
    }
}
