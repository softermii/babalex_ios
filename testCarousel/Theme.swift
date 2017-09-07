//
//  Theme.swift
//  testCarousel
//
//  Created by romiroma on 8/30/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

extension UIColor {
    static var defaultColorForTextAndUI: UIColor  { return UIColor(red: 1, green: 32.0/255.0, blue: 82.0/255.0, alpha: 1) }
    static var regularBlackColor: UIColor { return UIColor.black }
}

class Theme {
    struct Font {
        static let regularFontForCell: UIFont = UIFont(name: "GillSans-Light", size: 18) ?? UIFont.systemFont(ofSize: 18)
        static let selectedFontForCell: UIFont = UIFont(name: "GillSans-Semibold", size: 24) ?? UIFont.systemFont(ofSize: 24)
        static let badge: UIFont = UIFont(name: "GillSans-Bold", size: 9) ?? UIFont.systemFont(ofSize: 18)
    }
}
