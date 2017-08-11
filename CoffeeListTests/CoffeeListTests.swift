//
//  CoffeeListTests.swift
//  CoffeeListTests
//
//  Created by Christopher Szatmary on 2016-06-19.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import XCTest
@testable import CoffeeList
import CSKit

class CoffeeListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
        }
    }
    
    func testGetIndex() {
        let john: Entry? = Entry(name: "john", coffeeType: "DD", favCoffeeShop: "Tims", comments: nil)
        let john2: Entry? = Entry(name: "john", coffeeType: "DD", favCoffeeShop: "Tims", comments: nil)
        let eddy = Entry(name: "eddy", coffeeType: "2C", favCoffeeShop: "Tims", comments: nil)
        let array: [Entry]? = [john!, john2!, eddy]
        print(array?.index(of: john2!) ?? "Not in array")
        
    }
    
    func testCLType() {
        let john: Entry? = Entry(name: "john", coffeeType: "DD", favCoffeeShop: "Tims", comments: nil)
        let john2: Entry? = Entry(name: "john", coffeeType: "DD", favCoffeeShop: "Tims", comments: nil)
        let eddy = Entry(name: "eddy", coffeeType: "2C", favCoffeeShop: "Tims", comments: nil)
        //debugPrint(message: "john identical to john2", dataValue: john == john2)
        debugPrint("john? identical to john2?: \(john == john2)")
        debugPrint("john identical to eddy: \(john == eddy)")
        debugPrint("john not identical to john2: \(john != john2)")
        debugPrint("john not identical to eddy: \(john != eddy)")
        
        debugPrint("john? identical to john2!: \(john == john2!)")
        debugPrint("john! identical to john2?: \(john! == john2)")
        debugPrint("john! identical to john2!: \(john! == john2!)")
        
        var entries = [john!]
        debugPrint("john identical to john2: \(john == john2)")
        debugPrint("john equal to john2: \(String(describing: john?.isEqual(to: john2!)))")
        debugPrint("john not equal to john2: \(String(describing: john?.isNotEqual(to: john2!)))")
        entries.append(john2!)
        entries.remove(at: 0)
        debugPrint(eddy)
    }
    
    func testHasValue() {
        let x: Int? = nil
        self.measure {
            if x.hasValue {}
        }
    }
    
    func testBool() {
        let x: Int? = nil
        let notNil = x.hasValue
        self.measure {
            if notNil {}
        }
    }
    
    func testTime() {
        let x: Int? = nil
        let notNil = x.hasValue
        print(TimeMeasurer.measurer.measureTime {
            if x.hasValue {}
        })
        print(TimeMeasurer.measurer.measureTime {
            if notNil {}
        })
    }

}
