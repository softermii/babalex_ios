//
//  SFCarouselCollectionViewCell.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselCollectionViewCell: UICollectionViewCell {
    private var prevBlurRadius: CGFloat? = nil
    private var item: SFCarouselItem!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {

        guard let alpha = (layoutAttributes as? SFCarouselCollectionViewLayoutAttributes)?.textAlpha else {
            return
        }

        textContainer.alpha = alpha

        DispatchQueue.global(qos: .userInteractive).async {
            var blurRadius: CGFloat = 0
            guard let sfBlurRadius = (layoutAttributes as? SFCarouselCollectionViewLayoutAttributes)?.blurRadius else {
                return
            }

            if sfBlurRadius >= 0.4 && sfBlurRadius < 0.75 {
                blurRadius = 0.5
            } else if sfBlurRadius >= 0.75 && sfBlurRadius <= 1.5 {
                blurRadius = 1
            } else if sfBlurRadius > 1.5 && sfBlurRadius <= 2.5 {
                blurRadius = 1.5
            } else if sfBlurRadius > 2.5 {
                blurRadius = 3
            }

            if self.prevBlurRadius != blurRadius {
                self.prevBlurRadius = blurRadius

                DispatchQueue.main.async {
                    self.textContainer.unBlur()
                }

                if blurRadius != 0 {
                    DispatchQueue.main.async {
                        self.textContainer.blur(blurRadius: blurRadius)
                    }
                }
            }
        }
    }

    override func prepareForReuse() {
        prevBlurRadius = nil
        imageView.image = nil
    }

    public func setItem(item: SFCarouselItem) {
        self.item = item
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        self.priceLabel.text = String(item.price)
    }

    public func applyImage() {
        self.imageView.image = item.image
    }

}
