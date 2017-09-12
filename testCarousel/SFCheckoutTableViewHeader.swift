//
//  SFCheckoutTableViewHeader.swift
//  testCarousel
//
//  Created by romiroma on 9/11/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCheckoutTableViewHeader: CustomUIViewWithXib {

    @IBInspectable var title: String = "Cart" {
        didSet {
            guard
                subviews.count != 0
                else {
                    return
            }

            (subviews[0] as? UILabel)?.text = title
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        subviews[0].frame = bounds
    }

}
