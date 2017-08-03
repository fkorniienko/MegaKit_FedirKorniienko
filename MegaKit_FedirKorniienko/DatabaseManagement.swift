//
//  DatabaseManagement.swift
//  MegaKit_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.08.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManagement {
    static let shared:DatabaseManagement = DatabaseManagement()
    private let db: Connection?
    
    private let tableCar = Table("car")
    private let tableDriver = Table("Driver")

    private let id = Expression<Int64>("id")
    private let name = Expression<String?>("name")
    private let entityId = Expression<Int>("entityId")
    
    //init connection to sql
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/megaKit.sqlite3")
            print("\(path)/megaKit.sqlite3")
            createTableCar()
            createTableDriver()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createTableCar() {
        do {
            try db!.run(tableCar.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(entityId)
            })
            print("create table successfully")
        } catch {
            print("Unable to create table")
        }
    }
    
    // get relations by driver
    func selectCarByEntity (inputEntityId: Int) -> [Car]{
        var Cars = [Car]()
        do {
            for car in try db!.prepare(self.tableCar) {
                let newCar = Car(id: car[id],
                                 name: car[name] ?? "",
                                 entityId: car[entityId])
                if newCar.entityId == inputEntityId && inputEntityId != 0{
                Cars.append(newCar)
                }
            }
        } catch {
            print("Cannot get list of Car")
        }
        return Cars
    }
    
    //add new car
    func addCar(inputName: String, inputEntityId: Int) -> Int64? {
        do {
            let insert = tableCar.insert(name <- inputName, entityId <- inputEntityId)
            let id = try db!.run(insert)
            print("Insert to tblCar successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    //get list of cars
    func queryAllCar() -> [Car] {
        var Cars = [Car]()
        
        do {
            for car in try db!.prepare(self.tableCar) {
                let newCar = Car(id: car[id],
                                         name: car[name] ?? "",
                                         entityId: car[entityId])
                Cars.append(newCar)
            }
        } catch {
            print("Cannot get list of Car")
        }
        for Car in Cars {
            print("each Car = \(Car)")
        }
        return Cars
    }
    
    //update current car
    func updateCar(CarId:Int64, newCar: Car) -> Bool {
        let tblFilterCar = tableCar.filter(id == CarId)
        do {
            let update = tblFilterCar.update([
                name <- newCar.name,
                entityId <- newCar.entityId
                ])
            if try db!.run(update) > 0 {
                print("Update car successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }

    //delete current car
    func deleteCar(inputId: Int64) -> Bool {
        do {
            let tblFilterCar = tableCar.filter(id == inputId)
            try db!.run(tblFilterCar.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    //create table driver
    func createTableDriver() {
        do {
            try db!.run(tableDriver.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(entityId)
            })
            print("create table successfully")
        } catch {
            print("Unable to create table")
        }
    }
    
    //select relations by car
    func selectDriverByEntity (inputEntityId: Int) -> [Driver]{
        var Cars = [Driver]()
        do {
            for car in try db!.prepare(self.tableDriver) {
                let newCar = Driver(id: car[id],
                                 name: car[name] ?? "",
                                 entityId: car[entityId])
                if newCar.entityId == inputEntityId && inputEntityId != 0{
                    Cars.append(newCar)
                }
            }
        } catch {
            print("Cannot get list of Driver")
        }
        return Cars
    }
    
    //add new driver
    func addDriver(inputName: String, inputEntityId: Int) -> Int64? {
        do {
            let insert = tableDriver.insert(name <- inputName, entityId <- inputEntityId)
            let id = try db!.run(insert)
            print("Insert to tableDriver successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    //get all drivers
    func queryAllDriver() -> [Driver] {
        var Cars = [Driver]()
        
        do {
            for car in try db!.prepare(self.tableDriver) {
                let newDriver = Driver(id: car[id],
                                 name: car[name] ?? "",
                                 entityId: car[entityId])
                Cars.append(newDriver)
            }
        } catch {
            print("Cannot get list of Driver")
        }
        for Car in Cars {
            print("each Driver = \(Car)")
        }
        return Cars
    }
    
    //update current driver
    func updateDriver(CarId:Int64, newCar: Driver) -> Bool {
        let tblFilterCar = tableDriver.filter(id == CarId)
        do {
            let update = tblFilterCar.update([
                name <- newCar.name,
                entityId <- newCar.entityId
                ])
            if try db!.run(update) > 0 {
                print("Update driver successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    //delete current driver
    func deleteDriver(inputId: Int64) -> Bool {
        do {
            let tblFilterCar = tableDriver.filter(id == inputId)
            try db!.run(tblFilterCar.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
}
