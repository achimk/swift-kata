//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import CoreKit

final class PairTests: XCTestCase {
    
    func testParameters() {
        
        let pair = Pair(1, 2)
        
        XCTAssertEqual(pair.left, 1)
        XCTAssertEqual(pair.right, 2)
    }
    
    func testEqual() {
        let lhs = Pair(1, 2)
        let rhs = Pair(1, 2)
        
        XCTAssertTrue(lhs == rhs)
    }
    
    func testNonEqualByLeft() {
        let lhs = Pair(1, 2)
        let rhs = Pair(3, 2)
        
        XCTAssertFalse(lhs == rhs)
    }
    
    func testNonEqualByRight() {
        let lhs = Pair(1, 2)
        let rhs = Pair(1, 3)
        
        XCTAssertFalse(lhs == rhs)
    }
    
    func testEqualWithRightTuple() {
        let lhs = Pair(1, 2)
        let rhs = (1, 2)
        
        XCTAssertTrue(lhs == rhs)
    }
    
    func testEqualWithLeftTuple() {
        let lhs = (1, 2)
        let rhs = Pair(1, 2)
        
        XCTAssertTrue(lhs == rhs)
    }
}
