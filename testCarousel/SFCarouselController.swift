//
//  SFCarouselController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCarouselController: NSObject, SFCarouselControllerProtocol {

    var categories = [Category]()
    
    var viewControllers = [SFCategoryContentViewController]()
    var cellReuseIdentifier = {
        return "SFCarouselCollectionViewCell"
    }()

    internal func embedInViewController(_ viewController: UIViewController?, view: UIView?) {

        guard !self.categories.isEmpty else {
            fatalError("Categories cannot be empty at the when embeding in parent View contoller!")
        }

        self.categories.forEach { (c: Category) in
            let viewController = self.viewControllerForCategory(c)
            self.viewControllers.append(viewController)
        }

        let rootPager = SFCarouselVerticalPageViewController.init(self, firstViewController: self.viewControllers.first!)

        viewController?.addChildViewController(rootPager)
        view?.addSubview(rootPager.view)
        rootPager.didMove(toParentViewController: viewController)
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

    func viewControllerForCategory(_ category: Category) -> SFCategoryContentViewController {
        let vc = SFCategoryContentViewController.init(controller: self, categoryId: category.id)
        return vc
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSections = self.categories.isEmpty ? 0 : 1
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = self.categories[section].items.count
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SFCarouselCollectionViewCell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        DispatchQueue.global(qos: .userInteractive).async {
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
                    _cell.canApplyBlur = true

                }

            }
        }
    }
    

}
