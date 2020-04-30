//
//  OrdersTableViewControllerCell.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/28/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation
import UIKit

class OrdersTableViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
        
    func visualizeCell(orderViewModel: OrderViewModel) {
        self.nameLabel.text = orderViewModel.type
        self.sizeLabel.text = orderViewModel.size
    }
}
