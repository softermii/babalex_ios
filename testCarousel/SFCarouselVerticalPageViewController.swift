//
//  SFCarouselVerticalPageViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCarouselVerticalPageViewController: UIPageViewController, UIScrollViewDelegate {

    var backgroundView: UIScrollView!
    weak var controller: SFCarouselControllerProtocol?

    init(_ controller: SFCarouselControllerProtocol?, firstViewController: UIViewController) {
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        self.view.tag = 0
        
        self.delegate = controller
        self.dataSource = controller
        self.controller = controller

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

        setupBackroundView()
    }

    private func setupBackroundView() {
        let imageView = UIImageView.init(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "pattern_cupcakes")

        backgroundView = UIScrollView.init(frame: self.view.bounds)
        backgroundView.isUserInteractionEnabled = false

        backgroundView.addSubview(imageView)
        backgroundView.contentSize = imageView.bounds.size
        self.view.addSubview(backgroundView)
        self.view.sendSubview(toBack: backgroundView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let point = scrollView.contentOffset

//        var newContentOffset = point
//        backgroundView.setContentOffset(newContentOffset, animated: true)
//        print(newContentOffset, backgroundView.contentSize )


//        let percentComplete = fabs(point.y - view.frame.size.height)/view.frame.size.height
//        newContentOffset.y = point.y
//        print("vertical percentComplete:", percentComplete)


    }
}
