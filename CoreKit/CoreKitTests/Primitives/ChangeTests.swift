//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import CoreKit

final class ChangeTests: XCTestCase {
    
    func testInitializeWithValue() {
        let change = Change(1)
        expect(change.isModified) == false
        expect(change.original) == 1
        expect(change.value) == 1
    }
    
    func testInitializeWithEqualValues() {
        let change = Change(original: 1, value: 1)
        expect(change.isModified) == false
        expect(change.original) == 1
        expect(change.value) == 1
    }
    
    func testInitializeWithNonEqualValues() {
        let change = Change(original: 1, value: 2)
        expect(change.isModified) == true
        expect(change.original) == 1
        expect(change.value) == 2
    }
    
    func testUpdateWithEqualValue() {
        let change = Change(original: 1, value: 2).updated(1)
        expect(change.isModified) == false
        expect(change.original) == 1
        expect(change.value) == 1
    }
    
    func testUpdateWithNonEqualValue() {
        let change = Change(original: 1, value: 1).updated(2)
        expect(change.isModified) == true
        expect(change.original) == 1
        expect(change.value) == 2
    }
}
