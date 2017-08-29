//
//  Item.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import Foundation
import UIKit


class Category {
    let id: Int
    let title: String
    var items: [Item]
    let backgroundImageName: String
    lazy var image: UIImage? = {
        return UIImage(named: self.backgroundImageName)
    }()
    init(id: Int, title: String, backgroundImageName: String) {
        self.id = id
        self.title = title
        self.items = []
        self.backgroundImageName = backgroundImageName
    }

    func addItem(item: Item) {
        self.items.append(item)
    }
}

class Item {
    let id: Int
    let title, description: String
    let imageName: String
    let price: Double

    lazy var image: UIImage? = {
        return UIImage(named: self.imageName)
    }()

    init(id: Int, title: String, description: String, imageName: String, price: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.price = price
    }
}
