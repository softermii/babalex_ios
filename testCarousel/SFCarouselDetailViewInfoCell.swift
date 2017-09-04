//
//  SFCarouselDetailViewInfoCell.swift
//  testCarousel
//
//  Created by romiroma on 8/31/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselDetailViewInfoCell: UITableViewCell {

    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var detailInfoValue: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setup(labelText: String, valueText: String) {
        detailInfoLabel.text = labelText
        detailInfoValue.text = valueText
    }
    
}
