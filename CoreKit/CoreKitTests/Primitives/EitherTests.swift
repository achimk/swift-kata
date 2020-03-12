//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import CoreKit

class EitherTests: XCTestCase {
    
    func testInitializeLeft() {
        
        let either = Either<Int, String>(1)
        
        let value = retrieveLeft(from: either, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testInitializeRight() {
        
        let either = Either<Int, String>("a")
        
        let value = retrieveRight(from: either, otherwise: "b")
        
        XCTAssertEqual(value, "a")
    }
    
    func testLeftProperty() {
        
        let either = Either<Int, String>(1)
        
        XCTAssertEqual(either.left, 1)
    }
    
    func testRightProperty() {
        
        let either = Either<Int, String>("a")
        
        XCTAssertEqual(either.right, "a")
    }
    
    func testOnLeftClosure() {
        
        var value: Int = 0
        let either = Either<Int, String>(1)
        
        either.onLeft { value = $0 }
        
        XCTAssertEqual(value, 1)
    }
    
    func testOnRightClosure() {
        
        var value: String = "b"
        let either = Either<Int, String>("a")
        
        either.onRight { value = $0 }
        
        XCTAssertEqual(value, "a")
    }
    
    func testMap() {
        
        let either = Either<Int, String>("1").map { Int($0) ?? 0 }
        
        let value = retrieveRight(from: either, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testFlatMap() {
        
        let either = Either<Int, String>("1")
            .flatMap { _ in .right(1) }
        
        let value = retrieveRight(from: either, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testMapLeft() {
        
        let either = Either<Int, String>(1).mapLeft { String($0) }
        
        let value = retrieveLeft(from: either, otherwise: "0")
        
        XCTAssertEqual(value, "1")
    }
    
    func testFlatMapLeft() {
        
        let either = Either<Int, String>(1)
            .flatMapLeft { _ in .left("1") }
        
        let value = retrieveLeft(from: either, otherwise: "0")
        
        XCTAssertEqual(value, "1")
    }
    
    func testAnalyze() {
        
        let left: (Int) -> Int = { _ in 1 }
        let right: (String) -> Int = { _ in 2 }
        
        let outputLeft = Either<Int, String>(1).analyze(ifLeft: left, ifRight: right)
        let outputRight = Either<Int, String>("1").analyze(ifLeft: left, ifRight: right)
        
        XCTAssertEqual(outputLeft, 1)
        XCTAssertEqual(outputRight, 2)
    }
    
    private func retrieveLeft<T, U>(from either: Either<T, U>, otherwise: T) -> T {
        
        switch either {
        case .left(let value): return value
        case .right: return otherwise
        }
    }
    
    private func retrieveRight<T, U>(from either: Either<T, U>, otherwise: U) -> U {
        
        switch either {
        case .left: return otherwise
        case .right(let value): return value
        }
    }
}
