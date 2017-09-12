//
//  SFButton.swift
//  testCarousel
//
//  Created by romiroma on 9/6/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

@IBDesignable class SFButton: CustomUIViewWithXib {

    @IBInspectable var title: String = "ADD TO CART" {
        didSet {
            guard
                subviews.count != 0
                else {
                    return
            }

            (subviews[0] as? UIButton)?.titleLabel?.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        (subviews[0] as? UIButton)?.setTitle(title, for: .normal)
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
