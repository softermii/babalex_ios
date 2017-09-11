//
//  SFCheckoutViewController.swift
//  testCarousel
//
//  Created by romiroma on 9/8/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFBaseViewControllerProtocol {

    unowned var cartController: SFCartController
    private static let nibName = "SFCheckoutViewController"

    init(cartController: SFCartController) {
        self.cartController = cartController
        super.init(nibName: type(of: self).nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SFCartTableViewCell", for: indexPath)
        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkoutButtonAction() {
    }

}
