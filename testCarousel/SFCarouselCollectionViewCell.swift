//
//  SFCarouselCollectionViewCell.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCarouselCollectionViewCell: UICollectionViewCell {

    var prevBlurRadius: CGFloat? = nil
    var lastAttributes: SFCarouselCollectionViewLayoutAttributes? = nil
    var canApplyBlur = false
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

        guard let sfBlurRadius = (layoutAttributes as? SFCarouselCollectionViewLayoutAttributes)?.blurRadius else {
            return
        }

        guard canApplyBlur == true else {
            self.lastAttributes = layoutAttributes as? SFCarouselCollectionViewLayoutAttributes
            return
        }

        DispatchQueue.global(qos: .background).async {
            if self.prevBlurRadius != sfBlurRadius {
                self.prevBlurRadius = sfBlurRadius

                if sfBlurRadius == 0 {
                    if self.contentView.isBlurred {
                        DispatchQueue.main.async {
                            self.textContainer.unBlur()
                        }

                    }
                } else {
                    if self.contentView.isBlurred {
                        DispatchQueue.main.async {
                            self.textContainer.unBlur()
                        }
                    }
                    DispatchQueue.main.async {
                        self.textContainer.blur(blurRadius: sfBlurRadius)
                    }


                }
            }
        }



    }

    override func prepareForReuse() {
        prevBlurRadius = nil
        lastAttributes = nil
    }

}
