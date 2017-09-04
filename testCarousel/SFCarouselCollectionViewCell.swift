//
//  SFCarouselCollectionViewCell.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselCollectionViewCell: UICollectionViewCell {

    var prevBlurRadius: CGFloat? = nil
    var lastAttributes: SFCarouselCollectionViewLayoutAttributes? = nil

    var canApplyBlur = false {
        didSet {

        }
    }

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textContainer: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let alpha = (layoutAttributes as? SFCarouselCollectionViewLayoutAttributes)?.textAlpha else {
            return
        }

        self.textContainer.alpha = alpha

        var blurRadius: CGFloat = 0
        guard let sfBlurRadius = (layoutAttributes as? SFCarouselCollectionViewLayoutAttributes)?.blurRadius else {
            return
        }

        if sfBlurRadius >= 0.75 && sfBlurRadius <= 1.5 {
            blurRadius = 1
        } else if sfBlurRadius > 1.5 && sfBlurRadius <= 2.5 {
            blurRadius = 1.5
        } else if sfBlurRadius > 2.5 {
            blurRadius = 3
        }



//        guard  else {
//            self.lastAttributes = layoutAttributes as? SFCarouselCollectionViewLayoutAttributes
//            return
//        }

        DispatchQueue.global(qos: .userInteractive).async {
            if self.prevBlurRadius != blurRadius {
                self.prevBlurRadius = blurRadius

                if blurRadius == 0 {
                    if self.textContainer.isBlurred {
                        DispatchQueue.main.async {
                            self.textContainer.unBlur()
                        }

                    }
                } else {
                    if self.textContainer.isBlurred {
                        DispatchQueue.main.async {
                            self.textContainer.unBlur()
                        }
                    }
                    DispatchQueue.main.async {
                        self.textContainer.blur(blurRadius: blurRadius)
                    }
                }
            }
        }



    }

    override func prepareForReuse() {
        prevBlurRadius = nil
        lastAttributes = nil
        DispatchQueue.main.async {
            self.textContainer.unBlur()
        }
    }

}
