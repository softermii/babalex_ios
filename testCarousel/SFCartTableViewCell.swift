//
//  SFCartTableViewCell.swift
//  testCarousel
//
//  Created by romiroma on 9/11/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

protocol SFCartTableViewCellDelegate: class {
    func cartCountUpdated(id: Int, count: Int)
}

class SFCartTableViewCell: UITableViewCell {

    weak var delegate: SFCartTableViewCellDelegate?

    private var count: Int = 0 {
        didSet {
            if count > 0 {
                quantityLabel.text = String(count)
            }
        }
    }

    private var item: SFCarouselItem!

    @IBOutlet weak var productImageView: UIImageView!

    @IBOutlet weak var productTitleLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var quantityLabel: UILabel!

    
    @IBAction func decreaseCount() {
        count -= 1
        delegate?.cartCountUpdated(id: item.id, count: -1)
    }

    @IBAction func increaseCount() {
        count += 1
        delegate?.cartCountUpdated(id: item.id, count: 1)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        quantityLabel.layer.borderWidth = 2
        quantityLabel.layer.borderColor = productTitleLabel.textColor.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = quantityLabel.bounds.size
        quantityLabel.layer.cornerRadius = size.width / 2
    }

    func setup(_ item: SFCarouselItem, count: Int, delegate: SFCartTableViewCellDelegate?) {
        self.item = item
        self.delegate = delegate

        productTitleLabel.text = item.title
        productImageView.image = item.image
        priceLabel.text = String(item.price)
        quantityLabel.text = String(count)

        self.count = count
    }
    
}
