//
//  SFCarouselProtocols.swift
//  testCarousel
//
//  Created by romiroma on 8/23/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

protocol SFCarouselControllerProtocol:  UIPageViewControllerDataSource,
    UIPageViewControllerDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate {
    func embedInViewController(_ viewController: UIViewController?, view: UIView?)
    var cellReuseIdentifier: String { get }
}
