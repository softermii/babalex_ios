//
//  SFBlurable.swift
//  SFBlurable
//
//  Created by Roman Andrykevych on 24/08/2017.
//  Copyright © 2017 Softermii. All rights reserved.
//

import UIKit

extension UIView {

    func blur(blurRadius: CGFloat) {
        
        guard superview != nil,
            let blur = CIFilter(name: "CIGaussianBlur") else {
                return
        }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }

        UIGraphicsEndImageContext();

        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)

        let ciContext = UIViewBlurHelper.ciContext

        guard let result = blur.value(forKey: kCIOutputImageKey) as? CIImage else {
            return
        }

        let boundingRect = bounds

        let cgImage = ciContext.createCGImage(result, from: boundingRect)

        let blurCAOverlay = CALayer()
        blurCAOverlay.frame = frame
        blurCAOverlay.contents = cgImage
        blurCAOverlay.name = UIViewBlurHelper.blurableKey

        superview!.layer.addSublayer(blurCAOverlay)
        layer.isHidden = true

    }

    func unBlur() {
        guard let superViewSublayers = superview?.layer.sublayers else {
            return
        }

        for sublayer in superViewSublayers {
            if sublayer.name == UIViewBlurHelper.blurableKey {
                sublayer.removeFromSuperlayer()
                break
            }
        }

        layer.isHidden = false
    }

    var isBlurred: Bool {
        guard let superViewSublayers = superview?.layer.sublayers else {
            return false
        }

        for sublayer in superViewSublayers {
            if sublayer.name == UIViewBlurHelper.blurableKey {
                return true
            }
        }

        return false
    }
}

struct UIViewBlurHelper {
    static let blurableKey = "blurable"
    static let ciContext = CIContext.init(options: nil)
}
