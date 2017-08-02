//
//  DetailsVC.swift
//  MegaKit_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.08.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var carObject = [Car]()
    var driverObject = [Driver]()
    var segmentState = 0
    let reuseIdentifier = "MainTVCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEntity: UILabel!
    @IBOutlet weak var buttonChange: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelForSelectedItem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        initializeViews()
        buttonChange.addTarget(self, action: #selector(editTitle), for: .touchUpInside)
    }
    
    func initializeViews(){
        labelForSelectedItem.text  = segmentState == 0 ? "Change your Car name" : "Change your Driver name"
        textField.text = segmentState == 0 ? carObject.first!.name : driverObject.first!.name
        labelEntity.text = segmentState == 0 ? "Remove your Drivers" : "Remove your Cars"
    }
    
    func editTitle(){
        if textField.text == "" {
           textField.text = segmentState == 0 ? carObject.first!.name : driverObject.first!.name
        }else{
            _ = segmentState == 0 ? DatabaseManagement.shared.updateCar(CarId: self.carObject.first!.id!, newCar: Car.init(id: self.carObject.first!.id!, name: textField.text!, entityId: self.carObject.first!.entityId)) : DatabaseManagement.shared.updateDriver(CarId: self.driverObject.first!.id!, newCar: Driver.init(id: self.driverObject.first!.id!, name: self.textField.text!, entityId: self.driverObject.first!.entityId))
            
        }
        
    }
    // get gata from our tables
    func fetchData(){
        if segmentState == 1{
            self.carObject =  DatabaseManagement.shared.selectCarByEntity(inputEntityId: Int(driverObject.first!.entityId))
        }else{
            self.driverObject = DatabaseManagement.shared.selectDriverByEntity(inputEntityId: Int(carObject.first!.entityId))
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentState == 0 ? (driverObject.count ) : (carObject.count )
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: MainTVCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? MainTVCell {
            cell.labelTitle.text = segmentState == 1 ? carObject[indexPath.row].name : driverObject[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    // remove action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            var newDriver: Driver?
            var newCar: Car?
            if self.segmentState == 0{
                newDriver = Driver.init(id: self.driverObject[indexPath.row].id!, name: self.driverObject[indexPath.row].name, entityId: 0)
            }else{
                newCar = Car.init(id: self.carObject[indexPath.row].id!, name: self.carObject[indexPath.row].name, entityId: 0)
            }
            _ = self.segmentState == 1 ? DatabaseManagement.shared.updateCar(CarId: self.carObject[indexPath.row].id!, newCar: newCar!) : DatabaseManagement.shared.updateDriver(CarId: self.driverObject[indexPath.row].id!, newCar: newDriver!)
            self.fetchData()
        }
        return  [deleteAction]
    }
}
