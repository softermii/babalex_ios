//
//  SFBlurable.swift
//  SFBlurable
//
//  Created by Roman Andrykevych on 24/08/2017.
//  Copyright © 2017 Softermii. All rights reserved.
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

    func blur(blurRadius: CGFloat, providedCIContext: CIContext?)
    func unBlur()

    var isBlurred: Bool { get }
}

extension Blurable
{
    
    func blur(blurRadius: CGFloat, providedCIContext: CIContext? = nil)
    {
        guard self.superview != nil,
            let blur = CIFilter(name: "CIGaussianBlur"),
            let this = self as? UIView else {
            return
        }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext();

        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)

        let ciContext = providedCIContext ?? CIContext(options: nil)

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
        guard let sublayers = (self as? UIView)?.superview?.layer.sublayers else {
            return false
        }
        
        for v in sublayers {
            if v.name == BlurableKey.blurable {
                return true
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
