//
//  SFCarouselVerticalPageViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselVerticalPageViewController: UIPageViewController, UIScrollViewDelegate {

    var backgroundView: UIScrollView!
    var backgroundImages = [UIImage?]()
    weak var controller: SFCarouselControllerProtocol?
    weak var menuController: SFCarouselMenuControllerProtocol?
    var menuView: UITableView!
    var numberOfPages: CGFloat = 0

    private let backgroundParallaxMagicModifier: CGFloat = 0.5
    private var mainActionButton: UIButton!
    private var backgroundPatterns = [UIView]()
    private var pageHeight: CGFloat = 0
    private var backgroundPatternViewVerticalOffset: CGFloat = 0
    private var storedContentOffset: CGPoint? = nil

    init(_ controller: SFCarouselControllerProtocol?, menuController: SFCarouselMenuControllerProtocol?, firstViewController: UIViewController) {
        self.controller = controller
        self.menuController = menuController

        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)

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
        setupMainActionButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard storedContentOffset != nil else {
            return
        }

        backgroundView.setContentOffset(storedContentOffset!, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        storedContentOffset = self.backgroundView.contentOffset

    }

    private func setupBackroundView() {
        let cupcakesPattern = UIImage(named: "pattern_cupcakes")
        let macaronsPattern = UIImage(named: "pattern_macarons")

        self.backgroundImages = [cupcakesPattern, macaronsPattern]
        backgroundView = UIScrollView.init(frame: self.view.bounds)
        backgroundView.showsVerticalScrollIndicator = false
        backgroundView.showsHorizontalScrollIndicator = false
        backgroundView.isUserInteractionEnabled = false
        backgroundView.isScrollEnabled = false

        view.addSubview(backgroundView)
        view.sendSubview(toBack: backgroundView)

        let viewSize = self.view.bounds.size

        pageHeight = viewSize.height * self.backgroundParallaxMagicModifier
        backgroundPatternViewVerticalOffset = (pageHeight - viewSize.height) / 2

        for image in self.backgroundImages {
            guard image != nil else {
                continue
            }

            let yPosition = numberOfPages != 0 ? numberOfPages * viewSize.height + backgroundPatternViewVerticalOffset : 0

            let backgroundPatternView = UIImageView.init( frame: CGRect(x: 0, y: yPosition, width: viewSize.width, height: viewSize.height) )
            backgroundPatternView.image = image
            backgroundPatternView.contentMode = .scaleAspectFill

            backgroundPatterns.append(backgroundPatternView)
            backgroundView.addSubview(backgroundPatternView)

            numberOfPages += 1

        }
        backgroundView.bringSubview(toFront: backgroundPatterns.first!)
        backgroundView.contentSize = CGSize(width: viewSize.width, height: numberOfPages * pageHeight)
    }

    private func setupMenuView() {

        guard let cellReuseIdentifier = self.menuController?.tableViewCellReuseIdentifier else {
            return
        }

        let size = view.bounds.size
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

    private func setupMainActionButton() {
        self.mainActionButton = UIButton.init(type: .custom)
        self.mainActionButton.setTitle(Strings.MainActionButtonText.rawValue.uppercased(), for: .normal)
        self.mainActionButton.titleLabel?.font = UIFont(name: "GillSans-Semibold", size: 16)
        self.view.addSubview(self.mainActionButton)
        self.mainActionButton.translatesAutoresizingMaskIntoConstraints = false

        self.mainActionButton.backgroundColor = UIColor.blue
        self.mainActionButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.mainActionButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.mainActionButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.mainActionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    var prevContentOffset = CGPoint(x: 0, y: 0)
    var prevContentOffsetForMenu = CGPoint(x: 0, y: 0)
    var indexLimiter = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        prevContentOffset = scrollView.contentOffset
        prevContentOffsetForMenu = scrollView.contentOffset

        self.hideButton()

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.showButton()
    }

    private func hideButton() {
        UIView.animate(withDuration: 0.3) { 
            self.mainActionButton.transform = CGAffineTransform.init(translationX: 0, y: 100)
        }

    }

    private func showButton() {
        UIView.animate(withDuration: 0.3) {
            self.mainActionButton.transform = CGAffineTransform.identity
        }

    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.global(qos: .userInteractive).async {

            let contentOffset = scrollView.contentOffset

            let size = self.view.bounds.size

            var percentComplete = fabs(contentOffset.y - size.height) / size.height

            var directionItemShift: Int = 0
            var menuItemShift: Int = 0

            directionItemShift = contentOffset.y - self.prevContentOffset.y > 0 ? 1 : -1
            menuItemShift = contentOffset.y - self.prevContentOffsetForMenu.y > 0 ? 1 : -1

            if percentComplete > 0.4 && percentComplete < 0.6 {
                if abs(self.indexLimiter + menuItemShift) <= 1 && menuItemShift != 0 {
                    self.indexLimiter += menuItemShift
                    self.menuController?.setActiveMenuItemWithShift(self.indexLimiter)

                    DispatchQueue.main.async {
                        self.menuView.reloadData()
                    }
                }
            }

            self.updateBackgroundViewPosition(percentComplete, direction: directionItemShift)

            if percentComplete > 0.5 {
                percentComplete = 1 - percentComplete
            }

            self.updateMenuViewPosition(percentComplete)
            self.prevContentOffsetForMenu = contentOffset
        }

    }

    private func updateMenuViewPosition(_ percentScrolled: CGFloat) {

        let translationY = percentScrolled * self.view.bounds.size.height / 2 + self.menuView.contentSize.height / 2
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, translationY, 0)

        DispatchQueue.main.async {
            self.menuView.layer.transform = transform
            // Percents are getting values in 0...0.5, so we multiply twice with a little to make menu alpha = 1 earlier than 50%
            self.menuView.alpha = percentScrolled * 2.2
        }
    }

    private func updateBackgroundViewPosition(_ percentScrolled: CGFloat, direction: Int) {
        guard let currentPage: Int = self.controller?.currentPage,
            direction != 0 else {
                return
        }
        
        let normalizedToPageNumberContentOffset = (pageHeight - backgroundPatternViewVerticalOffset) * (CGFloat(currentPage) + CGFloat(direction) * percentScrolled)
        
        let contentOffset = CGPoint(x: 0, y: normalizedToPageNumberContentOffset)
        
        
        DispatchQueue.main.async {
            self.backgroundView.contentOffset = contentOffset
        }
    }
    
    
}
