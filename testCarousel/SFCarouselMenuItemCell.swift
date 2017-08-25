//
//  SFCarouselMenuItemCell.swift
//  testCarousel
//
//  Created by romiroma on 8/25/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCarouselMenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var selectedLine: UIView!

    static var selectedFont: UIFont = {
        let font = UIFont.init(name: "GillSans-Semibold", size: 24)
        return font ?? UIFont.systemFont(ofSize: 24)
    }()

    static var regularFont: UIFont = {
        let font = UIFont.init(name: "GillSans-Light", size: 18)
        return font ?? UIFont.systemFont(ofSize: 18)
    }()

    static var selectedColor: UIColor = UIColor.init(red: 1.0, green: 28.0/255.0, blue: 78.0/255.0, alpha: 1)
    static var regularColor: UIColor = UIColor.black

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let font = selected ? SFCarouselMenuItemCell.selectedFont : SFCarouselMenuItemCell.regularFont
        let color = selected ? SFCarouselMenuItemCell.selectedColor : SFCarouselMenuItemCell.regularColor

        DispatchQueue.main.async {
            self.itemTitleLabel.font = font
            self.itemTitleLabel.textColor = color
            self.selectedLine.isHidden = !selected
        }
    }
    
}
