//
//  Container.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-05.
//  Copyright © 2017 SzatmaryInc. All rights reserved.
//

import RealmSwift

class Container: Object {
    @objc dynamic var data = Data()
    @objc dynamic var typeName = ""
    @objc dynamic var id = ""
    
    convenience init(data: Data, typeName: String, id: String) {
        self.init()
        self.data = data
        self.typeName = typeName
        self.id = id
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
