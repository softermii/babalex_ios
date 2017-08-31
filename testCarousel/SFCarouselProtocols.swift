//
//  SFCarouselProtocols.swift
//  testCarousel
//
//  Created by romiroma on 8/23/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

protocol SFCarouselTransitionViewProvider {
    var viewForTransition: UIView? { get }
    var absoulteFrameForTransitionView: CGRect? { get }
    var view: UIView!{ get }

    func setViewForTransition(v: UIView)
    func setFrameForTransition(f: CGRect)
}
