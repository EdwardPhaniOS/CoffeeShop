//
//  Order.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/28/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

//Luu y: size: CoffeeSize la kieu chung chung may tinh khong hieu de decode
// size: CoffeeSize.RawValue may tinh se hieu la Raw Value trong CoffeeSize (Raw Value trong CoffeeSize co kieu la String), may tinh se decode duoc
struct Order: Codable {
    let name: String?
    let email: String?
    let type: CoffeeType.RawValue?
    let size: CoffeeSize.RawValue?
}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is not correct")
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?>  {
        
        let order = Order(vm)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is not correct")
        }
        
        guard let encodedData = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = encodedData
        
        return resource
    }
}

extension Order {
    
    //int?() = failable init, can return nil
    init?(_ vm: AddCoffeeOrderViewModel) {
        
        guard let name = vm.name,
            let email = vm.email,
            let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()),
            let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased())
            
            else { return nil }
        
        self.name = name
        self.email = email
        self.type = selectedType.rawValue
        self.size = selectedSize.rawValue
    }
}
