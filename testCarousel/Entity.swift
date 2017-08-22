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
    let backgroundImageName: String

    init(id: Int, title: String, backgroundImageName: String) {
        self.id = id
        self.title = title
        self.items = []
        self.backgroundImageName = backgroundImageName
    }

    mutating func addItem(item: Item) {
        self.items.append(item)
    }
}

struct Item {
    let id: Int
    let title, description: String
    let imageName: String
    let price: Double
}
