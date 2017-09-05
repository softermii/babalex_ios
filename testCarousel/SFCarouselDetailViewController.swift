//
//  SFCarouselDetailViewController.swift
//  testCarousel
//
//  Created by romiroma on 8/28/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCarouselDetailViewController: UIViewController, SFCarouselTransitionViewProvider, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    private static let nibName = "SFCarouselDetailViewController"
    private let cellReuseIdentifier = "SFCarouselDetailViewInfoCell"
    private var item: SFCarouselItem
    private var categoryImage: UIImage?

    private var imageTapGestureRecognizer: UITapGestureRecognizer!

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

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var ingredientsValue: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!

    required init(item: SFCarouselItem, categoryImage: UIImage?) {
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
        mainImageView.image = item.image
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        backgroundImageView.image = categoryImage

        if let ingredients = item.detailInfo["Ingredients"] {
            ingredientsValue.text = ingredients
        } else {
            ingredientsValue.isHidden = true
            ingredientsLabel.isHidden = true
        }
        let cellNib = UINib.init(nibName: cellReuseIdentifier, bundle: nil)
        detailTableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        detailTableView.estimatedRowHeight = 404
        detailTableView.rowHeight = UITableViewAutomaticDimension

        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        imageTapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        imageTapGestureRecognizer.numberOfTapsRequired = 1
        imageTapGestureRecognizer.delegate = self
        mainImageView.addGestureRecognizer(imageTapGestureRecognizer)
    }

    func handleTap(_ recognizer: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 1
            self.descriptionLabel.alpha = 1
            self.detailTableView.alpha = 1
            self.ingredientsLabel.alpha = 1
            self.ingredientsValue.alpha = 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.1) {
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
            self.detailTableView.alpha = 0
            self.ingredientsLabel.alpha = 0
            self.ingredientsValue.alpha = 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SFCarouselDetailViewInfoCell

        let sortedFlatMap = item.detailInfo.flatMap { (i: (key: String, value: String)) -> (String, String)? in
            if i.key != "Ingredients" {
                return (i.key, i.value)
            } else {
                return nil
            }
        }

        let tupleForCurrentCell = sortedFlatMap[indexPath.row]
        cell.setup(labelText: tupleForCurrentCell.0, valueText: tupleForCurrentCell.1)

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = item.detailInfo.count - 1
        return count > 0 ? count : 0
    }

}
