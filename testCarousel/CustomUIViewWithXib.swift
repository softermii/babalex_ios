//
//  CustomViewWithXib.swift
//  testCarousel
//
//  Created by romiroma on 9/6/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUIViewWithXib: UIControl {

    // MARK: init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonSetup()
    }

    // MARK: setup view

    fileprivate func loadViewFromNib() -> UIView {
        let viewBundle = Bundle(for: type(of: self))
        //  An exception will be thrown if the xib file with this class name not found,
        let view = viewBundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]
        return view as! UIView
    }

    fileprivate func commonSetup() {
        let nibView = loadViewFromNib()

        addSubview(nibView)
    }
}
