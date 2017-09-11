//
//  SFCarouselProtocols.swift
//  testCarousel
//
//  Created by romiroma on 8/23/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

protocol SFDatasource: class {
    func prepareItems()

    var categories: [SFCarouselCategory] { get }
}

protocol SFCartController: class {

    func addItemToCart(id: Int)
    func removeItemFromCart(id: Int)

    func numberOfItemsInCart(_ id: Int?) -> Int
    func numberOfItemTypesInCart() -> Int

    var cartOnUpdateNotificationName: Notification.Name { get }

    func item(_ index: Int) -> SFCarouselItem?
}

protocol SFCarouselTransitionViewProvider: class {
    var viewForTransition: UIView? { get }
    var absoulteFrameForTransitionView: CGRect? { get }
    var view: UIView!{ get }

    func setViewForTransition(v: UIView)
    func setFrameForTransition(f: CGRect)
}
