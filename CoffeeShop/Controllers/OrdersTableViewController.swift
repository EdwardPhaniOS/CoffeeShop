//
//  OrdersTableViewController.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/28/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderListViewController = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateOrder()
    }
    
    private func populateOrder() {
        
        //khi su dung self trong closure ma khong co weak self thi closure se luon co tham chieu manh toi  self (OrdersTableViewController) ==> self khong the bi tu dong xoa di khi khong can dung nua ==> Memory leak
        Webservice().load(resource: Order.all) { [weak self] result in
            switch result {
            case.success(let orders):
                
                self?.orderListViewController.ordersViewModel = orders.map({ (order) -> OrderViewModel in
                    return OrderViewModel(order: order)
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
                print("Error")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let addOrderVC = navC.viewControllers.first as? AddOrderViewController
            else { fatalError("Error performing segue") }
        
        addOrderVC.delegate = self
        
    }
    
}

//
//MARK: - OrdersTableViewController Delegate
//
extension OrdersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListViewController.numberOfRow(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewControllerCell", for: indexPath) as? OrdersTableViewControllerCell,
            let orderVM = orderListViewController.orderViewModel(at: indexPath.row)
            else {
                print("Error with cellForRowAt indexPath")
                return UITableViewCell()
        }
        
        cell.visualizeCell(orderViewModel: orderVM)
        
        return cell
    }
}

//
//MARK: - AddOrderViewControllerDelegate
//
extension OrdersTableViewController: AddOrderViewControllerDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, viewController: UIViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        orderListViewController.ordersViewModel.append(orderVM)
        
        let indexPath = IndexPath(row: orderListViewController.ordersViewModel.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
