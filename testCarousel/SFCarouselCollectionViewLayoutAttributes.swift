//
//  SFCarouselCollectionViewLayoutAttributes.swift
//  testCarousel
//
//  Created by romiroma on 8/23/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var blurRadius: CGFloat = 0
    var textAlpha: CGFloat = 0

    private var inheritedElementKind: String? = nil

    override var representedElementKind: String? {
        return inheritedElementKind
    }

    var inheritedElementCategory: UICollectionElementCategory? = nil
    override var representedElementCategory: UICollectionElementCategory {
        return inheritedElementCategory == nil ? UICollectionElementCategory.cell : inheritedElementCategory!
    }

    override init() {
        super.init()
    }

    init(attributes: UICollectionViewLayoutAttributes) {
        super.init()

        indexPath = attributes.indexPath
        inheritedElementKind = attributes.representedElementKind
        inheritedElementCategory = attributes.representedElementCategory

        transform3D = attributes.transform3D
        center.y = attributes.center.y
    }

    // MARK: NSCopying

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SFCarouselCollectionViewLayoutAttributes
        copy.blurRadius = blurRadius
        copy.textAlpha = textAlpha
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? SFCarouselCollectionViewLayoutAttributes {
            if blurRadius != rhs.blurRadius {
                return false
            }
            if textAlpha != rhs.textAlpha {
                return false
            }
            return super.isEqual(object)
        } else {
            return false
        }
    }

}
