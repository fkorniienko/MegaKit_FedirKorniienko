//
//  Driver.swift
//  MegaKit_FedirKorniienko
//
//  Created by Fedir Korniienko on 02.08.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import Foundation

class Driver: CustomStringConvertible {
    let id: Int64?
    var name: String
    var entityId: Int
    
    init(id: Int64, name: String, entityId: Int) {
        self.id = id
        self.name = name
        self.entityId = entityId
    }
    var description: String {
        return "id = \(self.id ?? 0), name = \(self.name), imageName = \(self.entityId)"
    }
}
