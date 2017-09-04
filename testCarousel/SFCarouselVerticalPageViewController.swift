//
//  SFCarouselVerticalPageViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselVerticalPageViewController: UIPageViewController, UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, SFCarouselTransitionViewProvider {

    private var lastViewForTransition: UIView? = nil
    private var lastFrameForTransition: CGRect? = nil

    func setViewForTransition(v: UIView) {
        lastViewForTransition = v
    }

    func setFrameForTransition(f: CGRect) {
        lastFrameForTransition = f
    }


    var absoulteFrameForTransitionView: CGRect? {
        get {
            return lastFrameForTransition
        }
    }

    var viewForTransition: UIView? {
        get {
            return lastViewForTransition
        }

    }

    private var categories = [Category]() {
        didSet {
            setupView()
        }
    }

    private var backgroundView: UIScrollView!

//    private weak var controller: SFCarouselControllerProtocol?

    private let menuCellReuseIdentifier = "SFCarouselMenuItemCell"
    private var currentCategoryIndex = 0
    private var currentMenuIndex = 0
    private var horizontalViewControllers: [SFCategoryContentViewController] = [SFCategoryContentViewController]()

    private var menuView: UITableView!
    private var swipeView: SFCarouselSwipeHintView!
    private var numberOfPages: CGFloat = 0

    private let backgroundParallaxMagicModifier: CGFloat = 0.5
    private var mainActionButton: UIButton!
    private var swipeHintView: UIView!
    private var backgroundPatterns = [UIView]()
    private var pageHeight: CGFloat = 0
    private var backgroundPatternViewVerticalOffset: CGFloat = 0
    private var storedBackgroundOffset: CGPoint? = nil

    private var prevContentOffset = CGPoint(x: 0, y: 0)
    private var prevContentOffsetForMenu = CGPoint(x: 0, y: 0)
    private var allowedSwitchDirection: Int = 0
    private var indexLimiter = 0

    required init?(coder: NSCoder) {

        let carouselController = SFCarouselController()
        carouselController.prepareDummyCarouselItems()
        categories = carouselController.categories

        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shopping-basket"), style: .plain, target: self, action: nil)

        var scrollView: UIScrollView?
        for v in view.subviews {
            if v as? UIScrollView != nil {
                scrollView = v as? UIScrollView

                scrollView!.delegate = self
                scrollView!.decelerationRate = UIScrollViewDecelerationRateFast
//                guard scrollView!.gestureRecognizers != nil,
//                    scrollView!.gestureRecognizers!.count > 2 else {
//                        return
//                }
//                scrollView!.gestureRecognizers?[2].removeTarget(nil, action: nil)
//                scrollView!.removeGestureRecognizer(scrollView!.gestureRecognizers![2])
                break
            }
        }

        setupView()
    }


    private func setupView() {
        setupViewControllers()
        setupSwipeHintView()
        setupMenuView()
        setupBackroundView()
        setupMainActionButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard storedBackgroundOffset != nil else {
            return
        }
        backgroundView.setContentOffset(storedBackgroundOffset!, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        storedBackgroundOffset = backgroundView.contentOffset
    }

    private func setupViewControllers() {
        guard !categories.isEmpty else {
            return
        }

        categories.forEach { (c: Category) in
            let vc = SFCategoryContentViewController(c)
            horizontalViewControllers.append(vc)
        }

        setViewControllers([horizontalViewControllers.first!], direction: .forward, animated: false) { (isSet: Bool) in }
    }

    private func setupBackroundView() {

        backgroundView = UIScrollView.init(frame: view.bounds)
        backgroundView.showsVerticalScrollIndicator = false
        backgroundView.showsHorizontalScrollIndicator = false
        backgroundView.isUserInteractionEnabled = false
        backgroundView.isScrollEnabled = false

        view.addSubview(backgroundView)
        view.sendSubview(toBack: backgroundView)

        let viewSize = view.bounds.size

        pageHeight = viewSize.height * backgroundParallaxMagicModifier
        backgroundPatternViewVerticalOffset = (pageHeight - viewSize.height) / 2

        for category in categories {
            let yPosition = numberOfPages != 0 ? numberOfPages * viewSize.height + backgroundPatternViewVerticalOffset : 0

            let backgroundPatternView = UIImageView( frame: CGRect(x: 0, y: yPosition, width: viewSize.width, height: viewSize.height) )

            backgroundPatternView.image = category.image
            backgroundPatternView.alpha = 0.3
            backgroundPatternView.contentMode = .scaleAspectFill

            backgroundPatterns.append(backgroundPatternView)
            backgroundView.addSubview(backgroundPatternView)

            numberOfPages += 1
        }

        backgroundView.bringSubview(toFront: backgroundPatterns.first!)
        backgroundView.contentSize = CGSize(width: viewSize.width, height: numberOfPages * pageHeight)
    }

    private func setupMenuView() {

        let size = view.bounds.size
        menuView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height / 2), style: .grouped)

        menuView.isUserInteractionEnabled = false
        menuView.isScrollEnabled = false

        menuView.alpha = 0

        let cellNib = UINib.init(nibName: menuCellReuseIdentifier, bundle: nil)
        menuView.register(cellNib, forCellReuseIdentifier: menuCellReuseIdentifier)
        menuView.backgroundColor = UIColor.clear
        menuView.separatorStyle = .none

        view.addSubview(menuView)
        view.sendSubview(toBack: menuView)

        menuView.dataSource = self
        menuView.delegate = self
    }

    private func setupMainActionButton() {
        mainActionButton = Theme.defaultActionButton()

        mainActionButton.setTitle(Strings.MainActionButtonText.rawValue.uppercased(), for: .normal)
        view.addSubview(mainActionButton)
        mainActionButton.translatesAutoresizingMaskIntoConstraints = false

        mainActionButton.backgroundColor = UIColor.defaultColorForTextAndUI
        mainActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainActionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainActionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func setupSwipeHintView() {
        swipeView = SFCarouselSwipeHintView.init(frame: CGRect.zero)
        guard categories.count > 1 else {
            return
        }

        swipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(swipeView)
        swipeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        swipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        swipeView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        swipeView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true

        swipeView.setTitle(categories[1].title.uppercased())
        view.sendSubview(toBack: swipeView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        prevContentOffset = scrollView.contentOffset
        prevContentOffsetForMenu = scrollView.contentOffset
        indexLimiter = 0
        allowedSwitchDirection = 0
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.global(qos: .userInteractive).async {

            let contentOffset = scrollView.contentOffset
            let viewHeight = self.view.bounds.size.height

            let percentComplete = fabs(contentOffset.y - viewHeight) / viewHeight
            let menuPositionPercentComplete = percentComplete > 0.5 ? 1 - percentComplete : percentComplete
            self.updateMenuViewPosition(menuPositionPercentComplete)

            let directionItemShift = contentOffset.y - self.prevContentOffset.y > 0 ? 1 : -1
            self.updateBackgroundViewPosition(percentComplete, direction: directionItemShift)

            if percentComplete > 0.45 && percentComplete < 0.55 {

                let menuItemShift = contentOffset.y - self.prevContentOffsetForMenu.y > 0 ? 1 : -1
                let isDirectionAllowed = self.allowedSwitchDirection == 0 || self.allowedSwitchDirection == menuItemShift

                if isDirectionAllowed {
                    if abs(self.indexLimiter + menuItemShift) <= 1 {
                        self.allowedSwitchDirection = -menuItemShift
                        self.indexLimiter += menuItemShift

                        let oldIndex = self.currentMenuIndex
                        let newIndex = oldIndex + menuItemShift
                        if newIndex >= 0 && newIndex < self.categories.count {
                            self.currentMenuIndex = newIndex

                            let indexPaths = [IndexPath(row: oldIndex, section: 0), IndexPath(row: newIndex, section: 0)]
                            DispatchQueue.main.async {
                                if self.categories.count > newIndex + 1 {
                                    self.swipeView.isHidden = false
                                    self.swipeView.setTitle(self.categories[newIndex + 1].title.uppercased())
                                } else {
                                    self.swipeView.isHidden = true
                                }

                                self.menuView.reloadRows(at: indexPaths, with: .automatic)
                            }
                        }

                    }
                }
            }
            self.prevContentOffsetForMenu = contentOffset
        }

    }

    private func updateMenuViewPosition(_ percentScrolled: CGFloat) {
        let translationY = percentScrolled * view.bounds.size.height / 2 + menuView.contentSize.height / 2
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, translationY, 0)

        DispatchQueue.main.async {
            self.menuView.layer.transform = transform
            self.menuView.alpha = percentScrolled * 2.2
            // Not a magic number ;)
            // percentScrolled are in 0...0.5, so we multiply with 2.2 to make menu alpha = 1 nearly when 45% of scroll completed
        }
    }

    private func updateBackgroundViewPosition(_ percentScrolled: CGFloat, direction: Int) {

        guard direction != 0 else {
            return
        }

        let updatedContentOffsetY = (pageHeight - backgroundPatternViewVerticalOffset) * (CGFloat(currentCategoryIndex) + CGFloat(direction) * percentScrolled)
        
        let contentOffset = CGPoint(x: 0, y: updatedContentOffsetY)
        
        DispatchQueue.main.async {
            self.backgroundView.contentOffset = contentOffset
        }
    }
    
    // MARK: UIPageViewController DataSource and Delegate methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let index = horizontalViewControllers.index(where: { (vc: UIViewController) -> Bool in
             return vc == viewController
        }) {
            if index < horizontalViewControllers.count - 1 {
                return horizontalViewControllers[index + 1]
            }
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if let index = horizontalViewControllers.index(where: { (vc: UIViewController) -> Bool in
            return vc == viewController
        }) {
            if index != 0 {
                return horizontalViewControllers[index - 1]
            }
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        if let indexOfViewController = self.horizontalViewControllers.index(where: { (vc: UIViewController) -> Bool in
            vc == pageContentViewController
        }) {
            currentCategoryIndex = indexOfViewController
        }
    }

    // MARK: UITableViewDataSource and UITableViewDelegate methods for menuView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellReuseIdentifier, for: indexPath) as! SFCarouselMenuItemCell
        cell.itemTitleLabel.text = categories[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isSelected = currentMenuIndex == indexPath.row
        cell.setSelected(isSelected, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
}
