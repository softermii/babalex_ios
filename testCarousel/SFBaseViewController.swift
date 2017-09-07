//
//  SFBaseViewController.swift
//  testCarousel
//
//  Created by romiroma on 9/7/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

public protocol SFBaseViewControllerWithCart {
    func leftBarButtonAction()
    func rightBarButtonAction()

    func cartUpdated(notification: Notification)
}

extension UIViewController: SFBaseViewControllerWithCart {
    public func leftBarButtonAction() {
        print("leftBarButtonItemClicked -")
    }

    public func rightBarButtonAction() {
        print("rightBarButtonItemClicked -")
    }

    public func cartUpdated(notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else {
            return
        }
        let textForBadge: String
        if count > 99 {
            textForBadge = "99+"
        } else {
            textForBadge = "\(count)"
        }
        navigationItem.rightBarButtonItem?.addBadge(text: textForBadge)
    }
}

protocol SFBaseViewControllerProtocol: class {
    weak var cartController: SFCartController? {
        get
    }
    func setupNavigationBarItems()
}

extension SFBaseViewControllerProtocol where Self: UIViewController {

    func setupNavigationBarItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)


        let basketImage = UIImage(named: "shopping-basket")
        let rightBarButtonItem = UIBarButtonItem( image: basketImage, style: .plain, target: self, action: #selector(rightBarButtonAction))
        navigationItem.rightBarButtonItem = rightBarButtonItem

        if type(of: self) != SFCarouselDetailViewController.self {
            let userImage = UIImage(named: "user")
            let leftBarButtonItem = UIBarButtonItem( image: userImage, style: .plain, target: self, action: #selector(leftBarButtonAction))
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }

        guard let numberOfItemsInCart = cartController?.numberOfItemsInCart(id: nil) else {
            return
        }

        if numberOfItemsInCart != 0 {
            let textForBadge: String
            if numberOfItemsInCart > 99 {
                textForBadge = "99+"
            } else {
                textForBadge = "\(numberOfItemsInCart)"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                rightBarButtonItem.addBadge(text: textForBadge)
            }
        }

        // Register to receive notification on cart updates
        if let notificationName = cartController?.cartOnUpdateNotificationName {
            NotificationCenter.default.addObserver(self, selector: #selector(type(of: self).cartUpdated), name: notificationName, object: nil)
        }
    }
}
