//
//  SFCarouselController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselController: NSObject, SFCarouselControllerProtocol, SFCarouselMenuControllerProtocol {

    private var categories = [Category]()
    private var currentCategoryIndex: Int = 0
    
    private var viewControllers = [SFCategoryContentViewController]()

    internal var cellReuseIdentifier = {
        return "SFCarouselCollectionViewCell"
    }()

    internal var tableViewCellReuseIdentifier = {
        return "SFCarouselMenuItemCell"
    }()

    private lazy var animationController: SFCarouselDetailAnimationController! = SFCarouselDetailAnimationController()

    private var lastIndex: Int? = nil

    internal var currentPage: Int {
        get {
            return lastIndex ?? 0
        }
    }

    internal func embedInViewController(_ viewController: UIViewController?, view: UIView?) {

        guard !self.categories.isEmpty else {
            fatalError("Categories cannot be empty at the when embeding in parent View contoller!")
        }

        self.categories.forEach { (c: Category) in
            let viewController = self.viewControllerForCategory(c)
            self.viewControllers.append(viewController)
        }

        let rootPager = SFCarouselVerticalPageViewController.init(self, menuController: self, firstViewController: self.viewControllers.first!)

        viewController?.addChildViewController(rootPager)
        view?.addSubview(rootPager.view)
        rootPager.didMove(toParentViewController: viewController)

        if let navigationController = viewController?.navigationController {
            navigationController.delegate = self
        }
    }

    public func prepareDummyCarouselItems() {
        let macarons = Category(id: 0, title: "Macarons", backgroundImageName: "pattern_macarons")
        let cupcakes = Category(id: 1, title: "Cupcakes", backgroundImageName: "pattern_cupcakes")

        var item: Item

        // Macarons
        item = Item(id: 1,
                    title: "Wandal Brunhilde Swanahilda",
                    description: "Dark Chocolate Macaron with Strawberry Buttercream and stars",
                    imageName: "macaron-1",
                    price: 4.99)
        macarons.addItem(item: item)

        item = Item(id: 2,
                    title: "Ricohard Giltbert Otto",
                    description: "White Chocolate Macaron with Strawberry Buttercream and stars",
                    imageName: "macaron-2",
                    price: 3.99)
        macarons.addItem(item: item)

        item = Item(id: 3,
                    title: "Alfher Hrodger Reinald",
                    description: "White Chocolate Macaron with Strawberry Buttercream and stars",
                    imageName: "macaron-3",
                    price: 2.99)
        macarons.addItem(item: item)

        item = Item(id: 4,
                    title: "Ida Albertus Willahelm",
                    description: "White Chocolate Macaron with Strawberry Buttercream and stars",
                    imageName: "macaron-4",
                    price: 3.99)
        macarons.addItem(item: item)

        item = Item(id: 5,
                    title: "Raginmund Hariman Auda",
                    description: "White Chocolate Macaron with Strawberry Buttercream and stars",
                    imageName: "macaron-5",
                    price: 1.99)
        macarons.addItem(item: item)


        // Cupcakes
        item = Item(id: 6,
                    title: "Verginius Pontius Rufinus",
                    description: "White Chocolate Cake with Strawberry Buttercream and stars",
                    imageName: "cupcake-1",
                    price: 4.59)
        cupcakes.addItem(item: item)

        item = Item(id: 7,
                    title: "Lucretia Claudius Rufinus",
                    description: "White Chocolate Cake with Strawberry Buttercream and stars",
                    imageName: "cupcake-2",
                    price: 4.95)
        cupcakes.addItem(item: item)

        item = Item(id: 8,
                    title: "Priscilla Marcell Cicero",
                    description: "White Chocolate Cake with Strawberry Buttercream and stars",
                    imageName: "cupcake-3",
                    price: 1.99)
        cupcakes.addItem(item: item)

        item = Item(id: 9,
                    title: "Quintilus Publius Balbus",
                    description: "White Chocolate Cake with Strawberry Buttercream and stars",
                    imageName: "cupcake-4",
                    price: 49.99)
        cupcakes.addItem(item: item)


        item = Item(id: 10,
                    title: "Maximinus Aulus Loukios",
                    description: "White Chocolate Cake with Strawberry Buttercream and stars",
                    imageName: "cupcake-5",
                    price: 5.99)
        cupcakes.addItem(item: item)
        categories.append(cupcakes)
        categories.append(macarons)

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.viewControllers.index(where: { (vc: SFCategoryContentViewController) -> Bool in return viewController == vc }) {
            if index < self.viewControllers.count - 1 {
                return self.viewControllers[index + 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.viewControllers.index(where: { (vc: SFCategoryContentViewController) -> Bool in return viewController == vc }) {
            if index > 0 {
                return self.viewControllers[index - 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        if let indexOfViewController = self.viewControllers.index(where: { (vc: SFCategoryContentViewController) -> Bool in
            vc == pageContentViewController
        }) {
            lastIndex = indexOfViewController
//            print("Index:", indexOfViewController)
        }
    }

    func viewControllerForCategory(_ category: Category) -> SFCategoryContentViewController {
        let vc = SFCategoryContentViewController.init(controller: self, categoryId: category.id)
        return vc
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSections = self.categories.isEmpty ? 0 : 1
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoryId = collectionView.tag
        if let category = self.categories.filter ({ (c: Category) -> Bool in
            c.id == categoryId
        }).first {
            return category.items.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SFCarouselCollectionViewCell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        DispatchQueue.global(qos: .background).async {
            let categoryId = collectionView.tag

            if let category = self.categories.filter ({ (c: Category) -> Bool in
                c.id == categoryId
            }).first {
                let item = category.items[indexPath.row]

                guard item.image != nil,
                    let _cell = cell as? SFCarouselCollectionViewCell,
                    let imageView = _cell.imageView
                    else {
                        return
                }
                let priceString = String(item.price)
                DispatchQueue.main.async {
                    imageView.image = item.image
                    _cell.titleLabel.text = item.title
                    _cell.descriptionLabel.text = item.description
                    _cell.priceLabel.text = priceString
//                    _cell.canApplyBlur = true
                }

            }
        }
    }

    var selectedViewForTransitioning: UIView? = nil

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .background).async {
            let categoryId = collectionView.tag
            
            if let category = self.categories.filter({ (c: Category) -> Bool in
                c.id == categoryId
            }).first {
                if let navigationController = self.viewControllers.first?.navigationController {
                    let item = category.items[indexPath.row]
                    let vc: SFCarouselDetailViewController = SFCarouselDetailViewController.init(item: item, categoryImage: category.image)
                    let cellImageView = (collectionView.cellForItem(at: indexPath) as? SFCarouselCollectionViewCell)?.imageView



                    DispatchQueue.main.async {
                        self.selectedViewForTransitioning = cellImageView
                        navigationController.pushViewController(vc, animated: true)
                    }
                }
            }

        }
    }


    // MARK: SFCarouselMenuControllerProtocol Conformance
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellReuseIdentifier, for: indexPath) as! SFCarouselMenuItemCell

        cell.itemTitleLabel.text = self.categories[indexPath.row].title

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isSelected = currentCategoryIndex == indexPath.row
        cell.setSelected(isSelected, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }

    func setActiveMenuItemWithShift(_ shift: Int) {
        let newIndex = self.currentCategoryIndex + shift
        if newIndex >= 0 && newIndex < self.categories.count {
            self.currentCategoryIndex = newIndex
        }
    }

    //UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
}
