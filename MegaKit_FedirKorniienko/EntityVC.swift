//
//  EntityVC.swift
//  MegaKit_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.08.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit

class EntityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var entityId = 0
    var addCount = 0
    var segmentState = 0
    var arrayText = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "StringTVCell", bundle: nil), forCellReuseIdentifier: "StringTVCell")
        tableView.register(UINib(nibName: "AddButtonTVCell", bundle: nil), forCellReuseIdentifier: "AddButtonTVCell")
        tableView.dataSource = self
        tableView.delegate = self
        buttonDone.addTarget(self, action: #selector(goToRootVC), for: .touchUpInside)
    }
    
    // finish editing and add to sql
    func goToRootVC(){
        if  arrayText.count != 0{
            for text in arrayText{
                if segmentState == 0{
                    _ = DatabaseManagement.shared.addDriver(inputName: text, inputEntityId: entityId)
                }else{
                    _ = DatabaseManagement.shared.addCar(inputName: text, inputEntityId: entityId)
                }
            }
        }
    navigationController?.popToRootViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2+addCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{

        case 0:
        if let cell: AddButtonTVCell = tableView.dequeueReusableCell(withIdentifier: "AddButtonTVCell") as? AddButtonTVCell {
                cell.buttonAdd.tag = indexPath.row + addCount
                cell.buttonAdd.addTarget(self, action: #selector(addCell(button:)), for: .touchUpInside)
            return cell
        }
        default: if let cell: StringTVCell = tableView.dequeueReusableCell(withIdentifier: "StringTVCell") as? StringTVCell {
                cell.textField.placeholder = segmentState == 0 ? "Select your Drivers" : "Select your Cars"
                cell.textField.delegate = self
            return cell
        }
        }
        return UITableViewCell()
    }

    // add new cell
    func addCell(button: UIButton) {
        addCount += 1
        tableView.insertRows(at: [IndexPath(row: addCount + 1, section: 0)], with: .automatic)
        button.tag += 1
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        arrayText.append(textField.text!)
    }
    
}
