//
//  OrderViewModel.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/28/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation

class OrderListViewModel {
    
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    
    func orderViewModel(at index: Int) -> OrderViewModel? {
        self.ordersViewModel[index]
    }
    
    func numberOfRow(in section: Int) -> Int {
        return ordersViewModel.count
    }
}

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    
    var name: String {
        return order.name ?? ""
    }
    
    var email: String {
        return order.email ?? ""
    }
    
    var size: String {
        return order.size?.capitalized ?? ""
    }
    
    var type: String {
        return order.type?.capitalized ?? ""
    }
    
    
    
    
}


