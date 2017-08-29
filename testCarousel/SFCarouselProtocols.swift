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
    UICollectionViewDelegate,
    UINavigationControllerDelegate {
    func embedInViewController(_ viewController: UIViewController?, view: UIView?)
    var cellReuseIdentifier: String { get }
    var currentPage: Int { get }
}

protocol SFCarouselMenuControllerProtocol: UITableViewDataSource, UITableViewDelegate {
    var tableViewCellReuseIdentifier: String { get }

    func setActiveMenuItemWithShift(_ shift: Int) // shift Can be -1 or 1 (previous-next)
}

protocol SFCarouselTransitionViewProvider {
    var viewForTransition: UIView? { get }
    var absoulteFrameForTransitionView: CGRect? { get }
    var view: UIView!{ get }
}
