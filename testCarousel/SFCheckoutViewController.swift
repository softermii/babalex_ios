//
//  SFCheckoutViewController.swift
//  testCarousel
//
//  Created by romiroma on 9/8/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit

final class SFCheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFBaseViewControllerProtocol, SFCartTableViewCellDelegate {

    unowned var cartController: SFCartController
    private static let nibName = "SFCheckoutViewController"
    let cellReuseIdentifier = "SFCartTableViewCell"
    weak var tableFooterView: SFCheckoutTableViewFooter?

    private var itemIndex = [Int: Int]()

    init(cartController: SFCartController) {
        self.cartController = cartController
        super.init(nibName: type(of: self).nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SFCartTableViewCell", for: indexPath) as! SFCartTableViewCell

        if let item = cartController.item(indexPath.row) {
            let count = cartController.numberOfItemsInCart(item.id)
            itemIndex[item.id] = indexPath.row
            cell.setup(item, count: count, delegate: self)

        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = cartController.numberOfItemTypesInCart()
        return count
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let frameForSupplementaryView = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height / 5)
        let headerView = SFCheckoutTableViewHeader(frame: frameForSupplementaryView)
        let footerView = SFCheckoutTableViewFooter(frame: frameForSupplementaryView)

        tableView.rowHeight = view.bounds.size.height / 5
        tableView.estimatedRowHeight = view.bounds.size.height / 5

        tableView.setTableHeaderView(headerView: headerView)


        let cellNib = UINib.init(nibName: cellReuseIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)

        setupNavigationBarItems()

        tableFooterView = footerView
        tableView.setTableFooterView(footerView: footerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateSummaryText()
    }
    
    @IBAction func checkoutButtonAction() {
        let code = cartController.codeForCheckout()
        let vc = SFCheckoutAlertViewController.init(code: code)

        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true, completion: nil)
    }

    func cartCountUpdated(id: Int, count: Int) {
        if count == -1 {

            cartController.removeItemFromCart(id: id)
            let newCount = cartController.numberOfItemsInCart(id)

            if newCount == 0 {
                if let row = itemIndex.removeValue(forKey: id) {
                    let indexPath = IndexPath(row: row, section: 0)

                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()

                    for item in itemIndex {
                        if item.value > row {
                            itemIndex[item.key] = item.value - 1
                        }
                    }

                }

            }
        } else {
            cartController.addItemToCart(id: id)
        }

        updateSummaryText()
    }

    private func updateSummaryText() {
        tableFooterView?.summaryLabel.text = cartController.summary()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UITableView {

    func setTableHeaderView(headerView: UIView) {
        // set the headerView
        tableHeaderView = headerView

        // force updated layout
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
    }

    func setTableFooterView(footerView: UIView) {
        // set the headerView
        tableFooterView = footerView

        // force updated layout
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
    }

}
