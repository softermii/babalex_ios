//
//  UIBarButtonItem+Badge.swift
//  testCarousel
//
//  Created by romiroma on 9/6/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func addBadge(text: String, offset: CGPoint = CGPoint(x: 0, y: 4), color: UIColor = UIColor.black, fontName: String = Theme.Font.badge.fontName) {

        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = text.characters.count <= 2 ? CGFloat(8) : CGFloat(9)

        guard let view = self.value(forKey: "view") as? UIView else {
            return
        }

        let location = CGPoint(x: view.frame.width - (radius + offset.x) - 5, y: (radius + offset.y))
        badge.drawCircleAtLocation(location, withRadius: radius, andColor: color)

        view.layer.addSublayer(badge)
        for layer in view.layer.sublayers! {
            if layer.name == "badge" {
                layer.removeFromSuperlayer()
                break
            }
        }
        badge.name = "badge"

        let label = CATextLayer()
        label.string = text
        label.alignmentMode = kCAAlignmentCenter
        label.font = CGFont( fontName  as CFString )
        label.fontSize = text.characters.count <= 2 ? CGFloat(11) : CGFloat(9)

        let offsetY = text.characters.count <= 2 ? offset.y + 1 : offset.y + 3

        label.frame = CGRect(origin: CGPoint(x: location.x - 8, y: offsetY), size: CGSize(width: 16, height: 16))
        label.foregroundColor = UIColor.white.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)

    }
}

extension CAShapeLayer {
    fileprivate func drawCircleAtLocation(_ location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor) {
        fillColor = color.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath.init(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2)) ).cgPath
    }
}
