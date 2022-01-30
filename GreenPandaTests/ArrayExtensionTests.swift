//
//  ArrayExtensionTests.swift
//  GreenPandaTests
//
//  Created by Matthew Mould on 30/01/2022.
//

import XCTest
import GreenPanda

class ArrayExtensionTests: XCTestCase {

    let array = ["A", "B", "C", "D", "E"]

    func testCanGetExistantElement()  {
        XCTAssertEqual(array[safe: 1]!, "B")
    }
    
    func testCanGetExistantElementWithNegativeIndexingw()  {
        XCTAssertEqual(array[safe: -1]!, "E")
    }
    
    func testCanGettingAnInvalidIndexReturnsNil()  {
        XCTAssertNil(array[safe: 5])
    }
    
    func testCanGettingAnInvalidNegativeIndexReturnsNil()  {
        XCTAssertNil(array[safe: -6])
    }
}

