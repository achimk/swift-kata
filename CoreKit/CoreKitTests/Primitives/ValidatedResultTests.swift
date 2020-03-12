//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import CoreKit

final class ValidatedResultTests: XCTestCase {
 
    func testInitializeValid() {
        
        let result = ValidatedResult<Int, String>.valid(1)
        
        let value = retrieveValid(from: result, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testInitializeInvalid() {
        
        let result = ValidatedResult<Int, String>.invalid("a")
        
        let value = retrieveInvalid(from: result, otherwise: "b")
        
        XCTAssertEqual(value, "a")
    }
    
    func testValidProperty() {
        
        let result = ValidatedResult<Int, String>.valid(1)
        
        XCTAssertEqual(result.value, 1)
    }
    
    func testInvalidProperty() {
        
        let result = ValidatedResult<Int, String>.invalid("a")
        
        XCTAssertEqual(result.error, "a")
    }
    
    func testIsValidProperty() {
     
        let result = ValidatedResult<Int, String>.valid(1)
        
        XCTAssertTrue(result.isValid)
        XCTAssertFalse(result.isInvalid)
    }
    
    func testIsInvalidProperty() {
        
        let result = ValidatedResult<Int, String>.invalid("a")
        
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.isInvalid)
    }
    
    func testIfValidClosure() {
        
        var value: Int = 0
        let result = ValidatedResult<Int, String>.valid(1)
        
        result.ifValid { value = $0 }
        
        XCTAssertEqual(value, 1)
    }
    
    func testIfInvalidClosure() {
        
        var value: String = "b"
        let result = ValidatedResult<Int, String>.invalid("a")
        
        result.ifInvalid { value = $0 }
        
        XCTAssertEqual(value, "a")
    }
    
    func testMap() {
        
        let result = ValidatedResult<String, Int>.valid("1").map { Int($0) ?? 0 }
        
        let value = retrieveValid(from: result, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testFlatMap() {
        
        let result = ValidatedResult<String, Int>.valid("1").flatMap { _ in .valid(1) }
        
        let value = retrieveValid(from: result, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testMapError() {
        
        let result = ValidatedResult<String, Int>.invalid(1).mapError { String($0) }
        
        let value = retrieveInvalid(from: result, otherwise: "0")
        
        XCTAssertEqual(value, "1")
    }
    
    func testFlatMapError() {
        
        let result = ValidatedResult<String, Int>.invalid(1).flatMapError { _ in .invalid("1") }
        
        let value = retrieveInvalid(from: result, otherwise: "0")
        
        XCTAssertEqual(value, "1")
    }
    
    func testAnalyze() {
        
        let valid: (Int) -> Int = { _ in 1 }
        let invalid: (String) -> Int = { _ in 2 }
        
        let outputValid = ValidatedResult<Int, String>.valid(1).analyze(valid: valid, invalid: invalid)
        let outputInvalid = ValidatedResult<Int, String>.invalid("1").analyze(valid: valid, invalid: invalid)
        
        XCTAssertEqual(outputValid, 1)
        XCTAssertEqual(outputInvalid, 2)
    }

    
    private func retrieveValid<T, U>(from either: ValidatedResult<T, U>, otherwise: T) -> T {
        
        switch either {
        case .valid(let value): return value
        case .invalid: return otherwise
        }
    }
    
    private func retrieveInvalid<T, U>(from either: ValidatedResult<T, U>, otherwise: U) -> U {
        
        switch either {
        case .valid: return otherwise
        case .invalid(let value): return value
        }
    }

}
