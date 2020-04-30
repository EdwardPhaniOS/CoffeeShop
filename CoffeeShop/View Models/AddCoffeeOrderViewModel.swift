//
//  AddCoffeeOrderViewModel.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/29/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedSize: String?
    var selectedType: String?
    
    var types: [String] {
        return CoffeeType.allCases.map {
            $0.rawValue.capitalized
        }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map {
            $0.rawValue.capitalized
        }
    }
    
}


