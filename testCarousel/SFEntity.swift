//
//  Item.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import Foundation
import UIKit


class SFCarouselCategory {
    let id: Int
    let title: String
    var items: [SFCarouselItem]
    let image: UIImage?

    init(id: Int, title: String, backgroundImageName: String) {
        self.id = id
        self.title = title
        self.items = []
        self.image = UIImage(named: backgroundImageName)
    }

    func addItem(item: SFCarouselItem) {
        self.items.append(item)
    }
}

class SFCarouselItem {
    let id: Int
    let title, description: String
    let price: Double
    let image: UIImage?

    var detailInfo: [String: String]

    init(id: Int, title: String, description: String, imageName: String, price: Double, detailInfo: [String: String]) {
        self.id = id
        self.title = title
        self.description = description
        self.image = UIImage(named: imageName)
        self.price = price
        self.detailInfo = detailInfo
    }
}
