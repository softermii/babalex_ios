//
//  SFCheckoutTableViewHeader.swift
//  testCarousel
//
//  Created by romiroma on 9/11/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCheckoutTableViewFooter: CustomUIViewWithXib {

    @IBInspectable var title: String = "Total" {
        didSet {
            guard
                subviews.count != 0
                else {
                    return
            }

            (subviews[0] as? UILabel)?.text = title
        }
    }

    @IBOutlet weak var summaryLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        subviews[0].frame = bounds
    }
    
}
