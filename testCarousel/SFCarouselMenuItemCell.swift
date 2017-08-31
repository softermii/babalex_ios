//
//  SFCarouselMenuItemCell.swift
//  testCarousel
//
//  Created by romiroma on 8/25/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselMenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var selectedLine: UIView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        let font = selected ? Theme.Font.selectedFontForCell : Theme.Font.regularFontForCell
        let color = selected ? UIColor.defaultColorForTextAndUI : UIColor.regularBlackColor

        itemTitleLabel.font = font
        itemTitleLabel.textColor = color
        selectedLine.isHidden = !selected
    }
    
}
