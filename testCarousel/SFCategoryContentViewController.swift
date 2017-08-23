//
//  SGCategoryContentViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCategoryContentViewController: UIViewController {

    private var controller: SFCarouselControllerProtocol
    private var categoryId: Int

    init(controller: SFCarouselControllerProtocol, categoryId: Int) {
        self.controller = controller
        self.categoryId = categoryId

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupCollectionView()
    }



    private func setupCollectionView() {
        let cellNib = UINib.init(nibName: "SFCarouselCollectionViewCell", bundle: nil)

        let itemWidth = 0.8 * self.view.bounds.size.width
        let itemHeight = 0.7 * self.view.bounds.size.height

        let layout = SFCarouselCollectionViewLayout.init()
        layout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)

        self.view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.tag = self.categoryId

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self.controller
        collectionView.dataSource = self.controller

        collectionView.register(cellNib, forCellWithReuseIdentifier: controller.cellReuseIdentifier)
        collectionView.isOpaque = false
        collectionView.backgroundColor = UIColor.clear
    }
}
