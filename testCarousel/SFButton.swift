//
//  SFButton.swift
//  testCarousel
//
//  Created by romiroma on 9/6/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

@IBDesignable class SFButton: CustomUIControlWithXib {

    @IBInspectable var title: String = "ADD TO CART" {
        didSet {
            guard
                subviews.count != 0,
                let button = subviews[0] as? UIButton else {
                    return
            }

            button.titleLabel?.text = title

        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        subviews[0].frame = bounds
    }

    override var isHighlighted: Bool {
        didSet {
            (subviews[0] as! UIButton).isHighlighted = isHighlighted
        }
    }


}
