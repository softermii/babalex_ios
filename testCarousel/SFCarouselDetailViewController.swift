//
//  SFCarouselDetailViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/28/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselDetailViewController: UIViewController, SFCarouselTransitionViewProvider {

    private static let nibName = "SFCarouselDetailViewController"

    private var item: Item
    private var categoryImage: UIImage?

    func setFrameForTransition(f: CGRect) {}
    func setViewForTransition(v: UIView) {}

    internal var viewForTransition: UIView? {
        get {
            return mainImageView
        }
    }

    internal var absoulteFrameForTransitionView: CGRect? {
        get {
            if let v = viewForTransition {
                return v.frame
            }

            return nil
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    required init(item: Item, categoryImage: UIImage?) {
        self.item = item
        self.categoryImage = categoryImage
        super.init(nibName: type(of: self).nibName, bundle: nil)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainImageView.image = item.image
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        self.backgroundImageView.image = categoryImage
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 1
            self.descriptionLabel.alpha = 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
        }
    }

}
