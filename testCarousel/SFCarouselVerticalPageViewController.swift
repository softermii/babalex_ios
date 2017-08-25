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
    weak var menuController: SFCarouselMenuControllerProtocol?
    var menuView: UITableView!

    init(_ controller: SFCarouselControllerProtocol?, menuController: SFCarouselMenuControllerProtocol?, firstViewController: UIViewController) {
        self.controller = controller
        self.menuController = menuController


        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)

        self.view.tag = 0

        self.delegate = controller
        self.dataSource = controller

        self.setViewControllers([firstViewController], direction: .forward, animated: true) { (isSet: Bool) in
            
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

        setupMenuView()
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

    private func setupMenuView() {

        guard let cellReuseIdentifier = self.menuController?.tableViewCellReuseIdentifier else {
            return
        }

        let size = self.view.bounds.size
        menuView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height / 2), style: .grouped)

        let cellNib = UINib.init(nibName: cellReuseIdentifier, bundle: nil)

        menuView.dataSource = menuController
        menuView.delegate = menuController

        menuView.isUserInteractionEnabled = false
        menuView.isScrollEnabled = false

        menuView.alpha = 0
        
        menuView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        menuView.backgroundColor = UIColor.clear
        menuView.separatorStyle = .none

        self.view.addSubview(menuView)
        self.view.sendSubview(toBack: menuView)
    }

    var prevContentOffset = CGPoint.init(x: 0, y: 0)
    var indexLimiter = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        prevContentOffset = scrollView.contentOffset
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        DispatchQueue.global(qos: .background).async {

            let contentOffset = scrollView.contentOffset
            
            let size = self.view.frame.size

            let directionIndexShift = contentOffset.y - self.prevContentOffset.y > 0 ? 1 : -1
            var percentComplete = fabs(contentOffset.y - size.height) / size.height

            if abs(self.indexLimiter + directionIndexShift) <= 1 {
                self.indexLimiter += directionIndexShift
                self.menuController?.setActiveMenuItemWithShift(self.indexLimiter)
            }

            if percentComplete > 0.5 {
                percentComplete = 1 - percentComplete
            }

            if percentComplete > 0.4 && percentComplete < 0.6 {
                DispatchQueue.main.async {
                    self.menuView.reloadData()
                }
            }

            self.updateMenuViewPosition(percentComplete)

            self.prevContentOffset = contentOffset
        }

    }

    private func updateMenuViewPosition(_ percentScrolled: CGFloat) {

        let translationY = percentScrolled * self.view.bounds.size.height / 2 + self.menuView.contentSize.height / 2
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, translationY, 0)

        DispatchQueue.main.async {
            self.menuView.layer.transform = transform
        }

        self.menuView.alpha = percentScrolled * 2.2
    }
}
