//
//  SFCarouselController.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselController: NSObject {

    public var categories = [SFCarouselCategory]()

    public func prepareDummyCarouselItems() {

        guard let path = Bundle.main.path(forResource: "babalex_dummy_info", ofType: "json") else {
            return
        }

        do {
            let resourceURL = URL(fileURLWithPath: path)

            let jsonData = try Data(contentsOf: resourceURL, options: Data.ReadingOptions.uncached)

            if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {

                let categoriesJSON = json["categories"] as? [[String: Any]]
                categoriesJSON?.forEach({ (categoryJSON: [String : Any]) in
                    guard
                        let id = categoryJSON["id"] as? Int,
                        let title = categoryJSON["title"] as? String,
                        let backgroundImageName = categoryJSON["image_name"] as? String

                        else {
                            fatalError("JSON is not formatted as expected")
                    }

                    let category = SFCarouselCategory.init(id: id, title: title, backgroundImageName: backgroundImageName)

                    if let itemsJSON = categoryJSON["items"] as? [[String: Any]] {

                        itemsJSON.forEach({ (itemJSON: [String : Any]) in
                            
                            guard
                                let id = itemJSON["id"] as? Int,
                                let title = itemJSON["title"] as? String,
                                let description = itemJSON["description"] as? String,
                                let imageName = itemJSON["image_name"] as? String,
                                let price = itemJSON["price"] as? Double,
                                let detailInfo = itemJSON["detail_info"] as? [String: String]
                            else {
                                return
                            }

                            let item = SFCarouselItem.init(id: id, title: title, description: description, imageName: imageName, price: price, detailInfo: detailInfo)
                            category.addItem(item: item)

                        })
                    }

                    categories.append(category)
                })

            } else {
                fatalError("JSON is not formatted as expected")
            }

        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

}
