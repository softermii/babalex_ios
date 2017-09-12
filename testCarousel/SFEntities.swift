//
//  Item.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import Foundation
import UIKit

final class SFCart {
    private var itemCounts: [Int: Int]

    init() {
        itemCounts = [:]
    }

    @discardableResult
    public func addItem(id: Int) -> Int {
        var itemCount = itemCounts[id] ?? 0
        itemCount += 1
        itemCounts[id] = itemCount
        return itemCount
    }

    @discardableResult
    public func removeItem(id: Int) -> Int {
        var itemCount = itemCounts[id] ?? 0

        if itemCount > 1 {
            itemCount -= 1
            itemCounts[id] = itemCount
        } else {
            itemCounts.removeValue(forKey: id)
            itemCount = 0
        }

        return itemCount
    }

    public func numberOfItems(id: Int?) -> Int {
        var numberOfItems = 0

        if id == nil {
            itemCounts.forEach({ (item: (_: Int, count: Int)) in
                if item.count != 0 {
                    numberOfItems += item.count
                }
            })
        } else {
            numberOfItems = itemCounts[id!] ?? 0
        }

        return numberOfItems
    }

    public func numberOfItemTypes() -> Int {
        var numberOfItems = 0

        let ids = Array(itemCounts.keys)
        for id in ids {
            if itemCounts[id] != nil && itemCounts[id] != 0 {
                numberOfItems += 1
            }
        }
        return numberOfItems
    }

    public func itemID(_ index: Int) -> Int? {
        let ids = Array(itemCounts.keys)
        if ids.count > index {
            return ids[index]
        }
        return nil
    }

    public func index(_ itemID: Int) -> Int? {
        let ids = Array(itemCounts.keys)

        var index = 0

        for id in ids {
            if id == itemID {
                return index
            }
            index += 1
        }

        return nil
    }

    public func allItems() -> Array<(id: Int, count: Int)> {
        var returned = Array<(id: Int, count: Int)>()

        itemCounts.forEach { (item: (id: Int, count: Int)) in
            if item.count != 0 {
                returned.append((id: item.id, count: item.count))
            }
        }

        return returned
    }

    public func generateCode() -> String {
        var returned: String = String()

        itemCounts.forEach { (item: (id: Int, count: Int)) in
            returned.append("\(item.id)\(item.count)")
        }

        return returned
    }
}

final class SFCarouselCategory {
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

final class SFCarouselItem {
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
