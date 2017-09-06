//
//  UIBarButtonItem+Badge.swift
//  testCarousel
//
//  Created by romiroma on 9/6/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func addBadge(text: String?, offset: CGPoint = CGPoint.zero, color: UIColor = UIColor.black) {
        guard let view = self.value(forKey: "view") as? UIView else { return }

        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x) - 5, y: (radius + offset.y))
        badge.drawCircleAtLocation(location, withRadius: radius, andColor: color)
        view.layer.addSublayer(badge)

        if text != nil {
            let label = CATextLayer()
            label.string = text!
            label.alignmentMode = kCAAlignmentCenter
            label.fontSize = 11
            label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
            label.foregroundColor = UIColor.white.cgColor
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            badge.addSublayer(label)
        }
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
