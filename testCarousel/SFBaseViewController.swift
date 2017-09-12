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

        guard let _self = self as? SFBaseViewControllerProtocol,
            self as? SFCheckoutViewController == nil else {
            return
        }

        let viewController = SFCheckoutViewController(cartController: _self.cartController)

        navigationController?.pushViewController(viewController, animated: true)
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
    unowned var cartController: SFCartController {
        get
    }
    func setupNavigationBarItems()
}

extension SFBaseViewControllerProtocol where Self: UIViewController {

    func setupNavigationBarItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)


        let basketImage = UIImage(named: "shopping-basket")

        let rightBarButtonItem = UIBarButtonItem( image: basketImage, style: .plain, target: self, action: #selector(rightBarButtonAction))

        if type(of: self) == SFCheckoutViewController.self {
            rightBarButtonItem.tintColor = UIColor.black
        } else {
            rightBarButtonItem.tintColor = UIColor.defaultColorForTextAndUI
        }

        navigationItem.rightBarButtonItem = rightBarButtonItem


        // Check if left "user button" is needed (it is only needed on the first screen)
        if self.navigationController?.viewControllers.count == 1 {
            let userImage = UIImage(named: "user")
            let leftBarButtonItem = UIBarButtonItem( image: userImage, style: .plain, target: self, action: #selector(leftBarButtonAction))
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }

        let numberOfItemsInCart = cartController.numberOfItemsInCart(nil)

        if numberOfItemsInCart != 0 {
            let textForBadge: String
            if numberOfItemsInCart > 99 {
                textForBadge = "99+"
            } else {
                textForBadge = "\(numberOfItemsInCart)"
            }

            let colorForBadge: UIColor

            if type(of: self) == SFCheckoutViewController.self {
                colorForBadge = UIColor.defaultColorForTextAndUI
            } else {
                colorForBadge = UIColor.black
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                rightBarButtonItem.addBadge(text: textForBadge, color: colorForBadge)
            }
        }

        // Register to receive notification on cart updates
        let notificationName = cartController.cartOnUpdateNotificationName
        NotificationCenter.default.addObserver(self, selector: #selector(type(of: self).cartUpdated), name: notificationName, object: nil)

    }
}
