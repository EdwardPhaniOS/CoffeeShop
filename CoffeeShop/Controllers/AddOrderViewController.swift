//
//  AddOrderViewController.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/28/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation
import UIKit

protocol AddOrderViewControllerDelegate: class {
    
    func addCoffeeOrderViewControllerDidSave(order: Order, viewController: UIViewController)
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var vm = AddCoffeeOrderViewModel()
    
    weak var delegate: AddOrderViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
    
    private func setupUI() {
        
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 16.0).isActive = true
        
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 1).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deSelectedCell = tableView.cellForRow(at: indexPath)
        deSelectedCell?.accessoryType = .none
    }
    
    @IBAction func close() {
        if let safeDelegate = self.delegate {
            safeDelegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
    }
    
    @IBAction func save() {
        
        let name = nameTextField.text!
        let email = emailTextField.text!
        
        let selectedIndex = self.coffeeSizesSegmentedControl.selectedSegmentIndex
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: selectedIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else { fatalError("Save new order error: no coffee selected") }
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: vm)) { (result) in
            switch result {
                
            case.success(let order):
                print(order ?? "order is nil")
                
                if let safeOrder = order,
                    let safeDelegate = self.delegate {
                    
                    DispatchQueue.main.async {
                        safeDelegate.addCoffeeOrderViewControllerDidSave(order: safeOrder, viewController: self)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
