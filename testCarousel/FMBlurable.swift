//
//  FMBlurable.swift
//  FMBlurable
//
//  Created by SIMON_NON_ADMIN on 18/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
// Thanks to romainmenke (https://twitter.com/romainmenke) for hint on a larger sample...

import UIKit


internal protocol Blurable
{
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var bounds: CGRect { get }
    var superview: UIView? { get }

    func addSubview(_ view: UIView)
    func removeFromSuperview()

    func blur(blurRadius: CGFloat)
    func unBlur()

    var isBlurred: Bool { get }
}

extension Blurable
{
    func blur(blurRadius: CGFloat)
    {
        guard self.superview != nil,
            let blur = CIFilter(name: "CIMotionBlur"),
            let this = self as? UIView else {
            return
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.size.width, height: bounds.size.height), false, 1)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext();

        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)

        let ciContext  = CIContext(options: nil)

        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage!

        let boundingRect = (self as! UIView).bounds

        let cgImage = ciContext.createCGImage(result!, from: boundingRect)

        let blurCAOverlay = BlurCAOverlay()
        blurCAOverlay.frame = frame
        blurCAOverlay.contents = cgImage
        blurCAOverlay.name = BlurableKey.blurable

        superview?.layer.addSublayer(blurCAOverlay)
        this.layer.isHidden = true

    }

    func unBlur()
    {
        var blurOverlay: BlurCAOverlay? = nil

        if let superview = (self as? UIView)?.superview {
            if let sublayers = superview.layer.sublayers {
                for v in sublayers {
                    if v.name == BlurableKey.blurable {
                        blurOverlay = v as? BlurCAOverlay
                        break
                    }
                }
            }

        }

        blurOverlay?.removeFromSuperlayer()

        (self as! UIView).layer.isHidden = false
    }
    
    var isBlurred: Bool
    {
        if let superview = (self as? UIView)?.superview {
            if let sublayers = superview.layer.sublayers {
                for v in sublayers {
                    if v.name == BlurableKey.blurable {
                        return true
                    }
                }
            }
        }

        return false
    }
}

extension UIView: Blurable
{
}

class BlurCAOverlay: CALayer {}

struct BlurableKey
{
    static var blurable = "blurable"
}
