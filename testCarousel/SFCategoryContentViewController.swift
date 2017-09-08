//
//  SGCategoryContentViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCategoryContentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var absoulteFrameForTransitionView: CGRect? {
        get {
            return viewForTransition?.frame
        }
    }


    var viewForTransition: UIView? {
        get {
            return selectedViewForTransitioning
        }
    }

    weak var currentItem: SFCarouselItem?

    private var category: SFCarouselCategory
    private let cellReuseIdentifier = "SFCarouselCollectionViewCell"
    private var collectionView: UICollectionView!

    private weak var selectedViewForTransitioning: UIView? = nil
    private weak var cartController: SFCartController?

    init(_ category: SFCarouselCategory, cartController: SFCartController?) {
        self.category = category
        self.cartController = cartController
        if !category.items.isEmpty {
            currentItem = category.items[0]
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {

        view.isOpaque = false
        view.backgroundColor = UIColor.clear

        let itemWidth = 0.8 * view.bounds.size.width
        let itemHeight = 0.7 * view.bounds.size.height

        let layout = SFCarouselCollectionViewLayout.init()
        layout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)

        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -65).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.isOpaque = false
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false


        let cellNib = UINib.init(nibName: cellReuseIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return category.items.isEmpty ? 0 : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return category.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SFCarouselCollectionViewCell

        cell.setItem(item: category.items[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        DispatchQueue.main.async {
            (cell as? SFCarouselCollectionViewCell)?.applyImage()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let navigationController = self.navigationController {
                let item = self.category.items[indexPath.row]
                let vc: SFCarouselDetailViewController = SFCarouselDetailViewController.init(frame: self.view.bounds,item: item, categoryImage: self.category.image, cartController: self.cartController)
                vc.view.frame = self.view.bounds
                if let cellImageView = (collectionView.cellForItem(at: indexPath) as? SFCarouselCollectionViewCell)?.imageView {

                    let transitionInfoProvider = self.parent as? SFCarouselTransitionViewProvider

                    let frameForTransition = cellImageView.convert(cellImageView.frame, to: self.view)

                    transitionInfoProvider!.setViewForTransition(v: cellImageView)
                    transitionInfoProvider!.setFrameForTransition(f: frameForTransition)

                }
                DispatchQueue.main.async {
                    navigationController.pushViewController(vc, animated: true)
                }
            }

        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        var rowIndexForCurrentItem: Int? = nil

        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems

        let centerOfCollectionView = collectionView.center

        switch indexPathsForVisibleItems.count {
        case 1: rowIndexForCurrentItem = indexPathsForVisibleItems[0].row
        case 2, 3:
            for indexPath in indexPathsForVisibleItems {
                if let cell = collectionView.cellForItem(at: indexPath) as? SFCarouselCollectionViewCell {
                    let cellFrameConverted = collectionView.convert(cell.frame, to: view)
                    if cellFrameConverted.contains(centerOfCollectionView) {
                        rowIndexForCurrentItem = indexPath.row


                        let transitionInfoProvider = self.parent as? SFCarouselTransitionViewProvider

//                        let frameForTransition = cellImageView.convert(cellImageView.frame, to: self.view)

                        transitionInfoProvider?.setViewForTransition(v: cell.imageView)
                        break
                    }
                }
            }
        default: break
        }

        if rowIndexForCurrentItem != nil {
            currentItem = category.items[rowIndexForCurrentItem!]
            print(currentItem!.title)
        }

    }
}
