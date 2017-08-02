//
//  AddVC.swift
//  MegaKit_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.08.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit
import SQLite
class AddVC: UIViewController {

    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDone.addTarget(self, action: #selector(addEntityVC), for: .touchUpInside)
        
    }

    // add element to sql and go to add new elements
    func addEntityVC(){
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.EntityVC) as? EntityVC {
            if segmentControl.selectedSegmentIndex == 0{
               let carObject =  DatabaseManagement.shared.queryAllCar()
                let entityId = carObject.count == 0 ? 1 : carObject.count + 1
             _ = DatabaseManagement.shared.addCar(inputName: textFieldTitle.text!, inputEntityId: entityId)
                destinationVC.entityId = entityId
            }else{
              let  driverObject =  DatabaseManagement.shared.queryAllCar()
                let entityId = driverObject.count == 0 ? 1 : driverObject.count + 1
                _ = DatabaseManagement.shared.addDriver(inputName: textFieldTitle.text!, inputEntityId: entityId)
                destinationVC.entityId = entityId
            }
            destinationVC.segmentState = segmentControl.selectedSegmentIndex
            self.show(destinationVC, sender: nil)
        }
    }
    

}
