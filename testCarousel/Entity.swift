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
    let title: String
    var items: [Item]

    init(title: String) {
        self.title = title
        self.items = []
    }

    mutating func addItem(item: Item) {
        self.items.append(item)
    }
}

struct Item {
    let title: String
    let image: UIImage
}
