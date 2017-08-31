//
//  Item.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import Foundation
import UIKit


struct Category {
    let id: Int
    let title: String
    var items: [Item]
//    let backgroundImageName: String
    let image: UIImage?

    init(id: Int, title: String, backgroundImageName: String) {
        self.id = id
        self.title = title
        self.items = []
        self.image = UIImage(named: backgroundImageName)
    }

    mutating func addItem(item: Item) {
        self.items.append(item)
    }
}

struct Item {
    let id: Int
    let title, description: String
    let price: Double

    var image: UIImage?


    init(id: Int, title: String, description: String, imageName: String, price: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.image = UIImage(named: imageName)
        self.price = price
    }
}
