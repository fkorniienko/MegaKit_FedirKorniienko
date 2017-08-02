//
//  ViewController.swift
//  MegaKit_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.08.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var carObject: [Car]?
    var driverObject: [Driver]?
    let reuseIdentifier = "MainTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        tableView.delegate = self
        tableView.dataSource = self
        segmentControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        fetchData()
    }
 
    // get gata from our tables
    func fetchData(){
        if segmentControl.selectedSegmentIndex == 0{
             self.carObject =  DatabaseManagement.shared.queryAllCar()
                self.driverObject = nil
        }else{
            self.driverObject = DatabaseManagement.shared.queryAllDriver()
            self.carObject = nil
        }
        tableView.reloadData()
    }
    
    // go to add new element
    func addItem(){
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.AddVC) as? AddVC {

            self.show(destinationVC, sender: nil)
        }

    }
    //MARK: TABLE VIEW DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carObject?.count == nil ? (self.driverObject?.count == nil ? 0 : self.driverObject?.count)! : (self.carObject?.count)!

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: MainTVCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? MainTVCell {
            cell.labelTitle.text = segmentControl.selectedSegmentIndex == 0 ? carObject![indexPath.row].name : driverObject![indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.DetailsVC) as? DetailsVC {
            if self.segmentControl.selectedSegmentIndex == 0{
                destinationVC.carObject.append((carObject?[indexPath.row])!)
            }else{
                destinationVC.driverObject.append((driverObject?[indexPath.row])!)
            }
            destinationVC.segmentState = self.segmentControl.selectedSegmentIndex
            self.show(destinationVC, sender: nil)
        }

    }
    
    // remove action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            _ = self.segmentControl.selectedSegmentIndex == 0 ? DatabaseManagement.shared.deleteCar(inputId: self.carObject![indexPath.row].id!) :  DatabaseManagement.shared.deleteDriver(inputId: self.driverObject![indexPath.row].id!)
            self.fetchData()
        }
        return  [deleteAction]
    }

}

