//
//  CheckoutAlertViewController.swift
//  testCarousel
//
//  Created by romiroma on 9/12/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

class SFCheckoutAlertViewController: UIViewController {

    private let code: String
    private static let nibName = "SFCheckoutAlertViewController"

    @IBOutlet weak var mainWindow: UIView!

    @IBOutlet weak var codeLabel: UILabel!

    @IBAction func okButtonAction() {
        dismiss(animated: true, completion: nil)
    }

    init(code: String) {
        self.code = code
        super.init(nibName: type(of: self).nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainWindow.layer.masksToBounds = true
        mainWindow.layer.cornerRadius = 10

        view.layer.shadowOffset = CGSize(width: -15, height: 20)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.5

        codeLabel.text = code
    }
}
