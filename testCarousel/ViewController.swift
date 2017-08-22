//
//  ViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var categories = [Category]()
    var collectionView: UICollectionView!
    let carouselCellReuseIdentifier = "CarouselCell"

    lazy var downSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let gestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(_:)))
        gestureRecognizer.direction = .down
        return gestureRecognizer
    }()

    lazy var upSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let gestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(_:)))
        gestureRecognizer.direction = .up
        return gestureRecognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        prepareCarouselItems()

        prepareCarouselView()
    }

    func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        print(sender.direction)
    }

    private func prepareCarouselItems() {
        var macarons = Category(title: "Macarons")

        if let itemImage = UIImage(named: "macaron-1") {
            let item = Item(title: "Wandal Brunhilde Swanahilda", image: itemImage)
            macarons.addItem(item: item)
        }

        if let itemImage = UIImage(named: "macaron-2") {
            let item = Item(title: "Ricohard Giltbert Otto", image: itemImage)
            macarons.addItem(item: item)
        }

        if let itemImage = UIImage(named: "macaron-3") {
            let item = Item(title: "Alfher Hrodger Reinald", image: itemImage)
            macarons.addItem(item: item)
        }

        if let itemImage = UIImage(named: "macaron-4") {
            let item = Item(title: "Ida Albertus Willahelm", image: itemImage)
            macarons.addItem(item: item)
        }

        if let itemImage = UIImage(named: "macaron-5") {
            let item = Item(title: "Raginmund Hariman Auda", image: itemImage)
            macarons.addItem(item: item)
        }

        var cupcakes = Category(title: "Cupcakes")

        if let itemImage = UIImage(named: "cupcake-1") {
            let item = Item(title: "Verginius Pontius Rufinus", image: itemImage)
            cupcakes.addItem(item: item)
        }

        if let itemImage = UIImage(named: "cupcake-2") {
            let item = Item(title: "Lucretia Claudius Rufinus", image: itemImage)
            cupcakes.addItem(item: item)
        }

        if let itemImage = UIImage(named: "cupcake-3") {
            let item = Item(title: "Priscilla Marcell Cicero", image: itemImage)
            cupcakes.addItem(item: item)
        }

        if let itemImage = UIImage(named: "cupcake-4") {
            let item = Item(title: "Quintilus Publius Balbus", image: itemImage)
            cupcakes.addItem(item: item)
        }

        if let itemImage = UIImage(named: "cupcake-5") {
            let item = Item(title: "Maximinus Aulus Loukios", image: itemImage)
            cupcakes.addItem(item: item)
        }

        self.categories.append(cupcakes)
    }

    private func prepareCarouselView() {
        let layout = CarouselViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib.init(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: carouselCellReuseIdentifier)

        collectionView.addGestureRecognizer(downSwipeGestureRecognizer)

        view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselCellReuseIdentifier, for: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = categories[section].items.count
        return numberOfItems
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSections = categories.count
        return numberOfSections
    }


}

