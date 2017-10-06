//
//  Persistable.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2017-10-05.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import SwiftySweetness

protocol Persistable where Self: Codable {
    static var typeName: String { get }
    var primaryKey: String { get }
    static func createFrom(realmContainer container: Container) throws -> Self
    func realmContainer() throws -> Container
}
