//
//  Created by Joachim Kret on 08/06/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
@testable import CoreKit

final class LinkedListTests: XCTestCase {
    
    // MARK: Test Create
    
    func test_createEmpty_shouldBeEmpty() {
        let list = LinkedList<Int>()
        expect(list.isEmpty) == true
    }
    
    func test_createWithOneElement_shouldNotBeEmpty() {
        let list = LinkedList<Int>(1)
        expect(list.isEmpty) == false
    }
    
    func test_createWithEmptyList_shouldBeEmpty() {
        let list = LinkedList<Int>([])
        expect(list.isEmpty) == true
    }
    
    func test_createWithNonEmptyArguments_shouldNotBeEmpty() {
        let list = LinkedList<Int>(1, 2, 3)
        expect(list.isEmpty) == false
    }
    
    func test_createWithNonEmptyList_shouldNotBeEmpty() {
        let list = LinkedList<Int>([1, 2, 3])
        expect(list.isEmpty) == false
    }
    
    func test_createWithOneElement_shouldMatchElement() {
        let list = LinkedList<Int>(1)
        let it = Array(list.makeIterator())
        expect(it) == [1]
    }
    
    func test_createWithNonEmptyArguments_shouldMatchElements() {
        let list = LinkedList<Int>(1, 2, 3)
        let it = Array(list.makeIterator())
        expect(it) == [1, 2, 3]
    }
    
    func test_createWithNonEmptyList_shouldMatchElements() {
        let list = LinkedList<Int>([1, 2, 3])
        let it = Array(list.makeIterator())
        expect(it) == [1, 2, 3]
    }
    
    // MARK: Test Append
    
    func test_appendElement_shouldContainAppendedElement() {
        var list = LinkedList<Int>()
        list.append(1)
        expect(Array(list.makeIterator())) == [1]
    }
    
    func test_multipleAppends_shouldContainAllElements() {
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        expect(Array(list.makeIterator())) == [1, 2, 3]
    }
    
    // MARK: Test Insert
    
    func test_insertToEmptyList_shouldContainFirstElement() {
        var list = LinkedList<Int>()
        list.insert(1, at: 0)
        expect(Array(list.makeIterator())) == [1]
    }
    
    func test_insertFirstIndexToOneElementList_elementShouldBeFirst() {
        var list = LinkedList<Int>(1)
        list.insert(4, at: 0)
        expect(Array(list.makeIterator())) == [4, 1]
    }
    
    func test_insertLastIndexToOneElementList_elementShouldBeLast() {
        var list = LinkedList<Int>(1)
        list.insert(4, at: 1)
        expect(Array(list.makeIterator())) == [1, 4]
    }
    
    func test_insertFirstIndex_elementShouldBeFirst() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 0)
        expect(Array(list.makeIterator())) == [4, 1, 2, 3]
    }
    
    func test_insertLastIndex_elementShouldBeLast() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 3)
        expect(list.count) == 4
        expect(list.last) == 4
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    func test_insertMiddleIndex_elementShouldBeIntMiddleIndex() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 2)
        expect(Array(list.makeIterator())) == [1, 2, 4, 3]
    }
    
    func test_multipleInsertionToEmptyList_shouldMatch() {
        var list = LinkedList<Int>()
        list.insert(1, at: 0)
        list.insert(2, at: 0)
        list.insert(3, at: 2)
        list.insert(4, at: 2)
        list.insert(5, at: 4)
        expect(Array(list.makeIterator())) == [2, 1, 4, 3, 5]
    }
    
    func test_multipleInsertionToNonEmptyList_shouldMatch() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(1, at: 0)
        list.insert(2, at: 0)
        list.insert(3, at: 4)
        list.insert(4, at: 4)
        list.insert(5, at: 7)
        expect(Array(list.makeIterator())) == [2, 1, 1, 2, 4, 3, 3, 5]
    }
    
    // MARK: Test Update
    
    func test_updateFirstIndex_shouldBeModified() {
        var list = LinkedList<Int>(1, 2, 3)
        list.update(4, at: 0)
        expect(Array(list.makeIterator())) == [4, 2, 3]
    }
    
    func test_updateLastIndex_shouldBeModified() {
        var list = LinkedList<Int>(1, 2, 3)
        list.update(4, at: 2)
        expect(Array(list.makeIterator())) == [1, 2, 4]
    }
    
    func test_updateMiddleIndex_shouldBeModified() {
        var list = LinkedList<Int>(1, 2, 3)
        list.update(4, at: 1)
        expect(Array(list.makeIterator())) == [1, 4, 3]
    }
    
    func test_updateAll_shouldHaveAllModified() {
        var list = LinkedList<Int>(1, 2, 3)
        list.update(4, at: 0)
        list.update(4, at: 1)
        list.update(4, at: 2)
        expect(Array(list.makeIterator())) == [4, 4, 4]
    }
    
    // MARK: Test Remove
    
    func test_removeElementFromOneElementList_shouldBeEmpty() {
        var list = LinkedList<Int>(1)
        list.remove(at: 0)
        expect(list.isEmpty) == true
    }
    
    func test_removeFirstIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 0)
        expect(Array(list.makeIterator())) == [2, 3]
    }
    
    func test_removeLastIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 2)
        expect(Array(list.makeIterator())) == [1, 2]
    }
    
    func test_removeMiddleIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 1)
        expect(Array(list.makeIterator())) == [1, 3]
    }
    
    func test_removeAllElementsFromFront_shouldBeEmpty() {
        var list = LinkedList<Int>(1, 2, 3)
        var count = list.count
        while count > 0 {
            count -= 1
            list.remove(at: 0)
        }
        expect(list.isEmpty) == true
    }
    
    func test_removeAllElementsFromBack_shouldBeEmpty() {
        var list = LinkedList<Int>(1, 2, 3)
        var index = list.count - 1
        repeat {
            list.remove(at: index)
            index -= 1
        } while index >= 0
        expect(list.isEmpty) == true
    }
    
    // MARK: Test Remove All
    
    func test_removeAllOnEmptyList_shouldBeEmpty() {
        var list = LinkedList<Int>()
        list.removeAll()
        expect(list.isEmpty) == true
    }
    
    func test_removeAllOnNontEmptyList_shouldBeEmpty() {
        var list = LinkedList<Int>(1, 2, 3)
        list.removeAll()
        expect(list.isEmpty) == true
    }
    
    // MARK: Test Subscript
    
    func test_subscriptValues_shouldReturnValidValue() {
        let list = LinkedList<Int>(1, 2, 3)
        expect(list[0]) == 1
        expect(list[1]) == 2
        expect(list[2]) == 3
    }
    
    func test_safeSubscriptValues_shouldReturnValidValue() {
        let list = LinkedList<Int>(1, 2, 3)
        expect(list[safe: 0]) == 1
        expect(list[safe: 1]) == 2
        expect(list[safe: 2]) == 3
        expect(list[safe: 3]).to(beNil())
    }
    
    // MARK: Test Count
    
    func test_emptyList_shouldBeZero() {
        let list = LinkedList<Int>()
        expect(list.count) == 0
    }
    
    func test_nonEmptyList_shouldMatchCount() {
        let list = LinkedList<Int>(1, 2, 3)
        expect(list.count) == 3
    }
    
    // MARK: Test Ierators
    
    func test_defaultInterator_shouldIterateAllValues() {
        let list = LinkedList<Int>(1, 2, 3, 4, 5)
        let it = Array(list.makeIterator())
        expect(it) == [1, 2, 3, 4, 5]
    }
    
    func test_forewardIterator_shouldIterateAllValuesWithRightOrder() {
        let list = LinkedList<Int>(1, 2, 3, 4, 5)
        let it = Array(list.makeForewardIterator())
        expect(it) == [1, 2, 3, 4, 5]
    }
    
    func test_backwardIterator_shouldIterateAllValuesWithRightOrder() {
        let list = LinkedList<Int>(1, 2, 3, 4, 5)
        let it = Array(list.makeBackwardIterator())
        expect(it) == [5, 4, 3, 2, 1]
    }
    
    // MARK: Test Copy On Write
    
    func test_append_shouldBeCopied() {
        let listA = LinkedList<Int>(1, 2, 3)
        var listB = listA
        listB.append(4)
        expect(Array(listA.makeIterator())) == [1, 2, 3]
        expect(Array(listB.makeIterator())) == [1, 2, 3, 4]
    }
    
    func test_insert_shouldBeCopied() {
        let listA = LinkedList<Int>(1, 2, 3)
        var listB = listA
        listB.insert(4, at: 0)
        expect(Array(listA.makeIterator())) == [1, 2, 3]
        expect(Array(listB.makeIterator())) == [4, 1, 2, 3]
    }
    
    func test_update_shouldBeCopied() {
        let listA = LinkedList<Int>(1, 2, 3)
        var listB = listA
        listB.update(4, at: 0)
        expect(Array(listA.makeIterator())) == [1, 2, 3]
        expect(Array(listB.makeIterator())) == [4, 2, 3]
    }
    
    func test_remove_shouldBeCopied() {
        let listA = LinkedList<Int>(1, 2, 3)
        var listB = listA
        listB.remove(at: 0)
        expect(Array(listA.makeIterator())) == [1, 2, 3]
        expect(Array(listB.makeIterator())) == [2, 3]
    }
    
    func test_removeAll_shouldBeCopied() {
        let listA = LinkedList<Int>(1, 2, 3)
        var listB = listA
        listB.removeAll()
        expect(Array(listA.makeIterator())) == [1, 2, 3]
        expect(Array(listB.makeIterator())) == []
    }
}

final class LinkedListForewardIteratorTests: XCTestCase {
    
    // MARK: Test Append
    
    func test_appendElement_shouldContainAppendedElement() {
        var list = LinkedList<Int>()
        list.append(1)
        let it = Array(list.makeForewardIterator())
        expect(it) == [1]
    }
    
    func test_multipleAppends_shouldContainAllElements() {
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        let it = Array(list.makeForewardIterator())
        expect(it) == [1, 2, 3]
    }
    
    // MARK: Test Insert
    
    func test_insertToEmptyList_shouldContainFirstElement() {
        var list = LinkedList<Int>()
        list.insert(1, at: 0)
        expect(Array(list.makeForewardIterator())) == [1]
    }
    
    func test_insertFirstIndexToOneElementList_elementShouldBeFirst() {
        var list = LinkedList<Int>(1)
        list.insert(4, at: 0)
        expect(Array(list.makeForewardIterator())) == [4, 1]
    }
    
    func test_insertLastIndexToOneElementList_elementShouldBeLast() {
        var list = LinkedList<Int>(1)
        list.insert(4, at: 1)
        expect(Array(list.makeForewardIterator())) == [1, 4]
    }
    
    func test_insertFirstIndex_elementShouldBeFirst() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 0)
        expect(Array(list.makeForewardIterator())) == [4, 1, 2, 3]
    }
    
    func test_insertLastIndex_elementShouldBeLast() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 3)
        expect(Array(list.makeForewardIterator())) == [1, 2, 3, 4]
    }
    
    func test_insertMiddleIndex_elementShouldBeIntMiddleIndex() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 2)
        expect(Array(list.makeForewardIterator())) == [1, 2, 4, 3]
    }
    
    func test_multipleInsertionToEmptyList_shouldMatch() {
        var list = LinkedList<Int>()
        list.insert(1, at: 0)
        list.insert(2, at: 0)
        list.insert(3, at: 2)
        list.insert(4, at: 2)
        list.insert(5, at: 4)
        expect(Array(list.makeForewardIterator())) == [2, 1, 4, 3, 5]
    }
    
    func test_multipleInsertionToNonEmptyList_shouldMatch() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(1, at: 0)
        list.insert(2, at: 0)
        list.insert(3, at: 4)
        list.insert(4, at: 4)
        list.insert(5, at: 7)
        expect(Array(list.makeForewardIterator())) == [2, 1, 1, 2, 4, 3, 3, 5]
    }
    
    // MARK: Test Remove
    
    func test_removeFirstIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 0)
        expect(Array(list.makeForewardIterator())) == [2, 3]
    }
    
    func test_removeLastIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 2)
        expect(Array(list.makeForewardIterator())) == [1, 2]
    }
    
    func test_removeMiddleIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 1)
        expect(Array(list.makeForewardIterator())) == [1, 3]
    }
}

final class LinkedListBackwardIteratorTests: XCTestCase {
    
    // MARK: Test Append
    
    func test_appendElement_shouldContainAppendedElement() {
        var list = LinkedList<Int>()
        list.append(1)
        let it = Array(list.makeBackwardIterator())
        expect(it) == [1]
    }
    
    func test_multipleAppends_shouldContainAllElements() {
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        let it = Array(list.makeBackwardIterator())
        expect(it) == [3, 2, 1]
    }
    
    // MARK: Test Insert
    
    func test_insertToEmptyList_shouldContainFirstElement() {
        var list = LinkedList<Int>()
        list.insert(1, at: 0)
        expect(Array(list.makeBackwardIterator())) == [1]
    }
    
    func test_insertFirstIndexToOneElementList_elementShouldBeFirst() {
        var list = LinkedList<Int>(1)
        list.insert(4, at: 0)
        expect(Array(list.makeBackwardIterator())) == [1, 4]
    }
    
    func test_insertLastIndexToOneElementList_elementShouldBeLast() {
        var list = LinkedList<Int>(1)
        list.insert(4, at: 1)
        expect(Array(list.makeBackwardIterator())) == [4, 1]
    }
    
    func test_insertFirstIndex_elementShouldBeFirst() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 0)
        expect(Array(list.makeBackwardIterator())) == [3, 2, 1, 4]
    }
    
    func test_insertLastIndex_elementShouldBeLast() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 3)
        expect(Array(list.makeBackwardIterator())) == [4, 3, 2, 1]
    }
    
    func test_insertMiddleIndex_elementShouldBeIntMiddleIndex() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(4, at: 2)
        expect(Array(list.makeBackwardIterator())) == [3, 4, 2, 1]
    }
    
    func test_multipleInsertionToEmptyList_shouldMatch() {
        var list = LinkedList<Int>()
        list.insert(1, at: 0)
        list.insert(2, at: 0)
        list.insert(3, at: 2)
        list.insert(4, at: 2)
        list.insert(5, at: 4)
        expect(Array(list.makeBackwardIterator())) == [5, 3, 4, 1, 2]
    }
    
    func test_multipleInsertionToNonEmptyList_shouldMatch() {
        var list = LinkedList<Int>(1, 2, 3)
        list.insert(1, at: 0)
        list.insert(2, at: 0)
        list.insert(3, at: 4)
        list.insert(4, at: 4)
        list.insert(5, at: 7)
        expect(Array(list.makeBackwardIterator())) == [5, 3, 3, 4, 2, 1, 1, 2]
    }
    
    // MARK: Test Remove
    
    func test_removeFirstIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 0)
        expect(Array(list.makeBackwardIterator())) == [3, 2]
    }
    
    func test_removeLastIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 2)
        expect(Array(list.makeBackwardIterator())) == [2, 1]
    }
    
    func test_removeMiddleIndex_shouldNotContainElement() {
        var list = LinkedList<Int>(1, 2, 3)
        list.remove(at: 1)
        expect(Array(list.makeBackwardIterator())) == [3, 1]
    }
}

final class LinkedListStorageTests: XCTestCase {
    
    func test_insertOnEmptyList_shouldPass() throws {
        let list = LinkedListStorage<Int>()
        try list.insert(1, at: 0)
        expect(Array(list.makeIterator())) == [1]
    }
    
    func test_insertOnLastIndex_shouldPass() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.insert(1, at: 3)
        expect(Array(list.makeIterator())) == [1, 2, 3, 1]
    }
    
    func test_insertOutOfLowerBound_shouldThrowError() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result(catching: { try list.insert(1, at: -1) })
        guard let error = result.error, case LinkedListError.outOfBounds = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_insertOutOfUpperBound_shouldThrowError() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result(catching: { try list.insert(1, at: 4) })
        guard let error = result.error, case LinkedListError.outOfBounds = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_updateOnEmptyList_shouldThrowError() {
        let list = LinkedListStorage<Int>()
        let result = Result(catching: { try list.update(1, at: 0) })
        guard let error = result.error, case LinkedListError.empty = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_updateOutOfLowerBound_shouldThrowError() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result(catching: { try list.update(1, at: -1) })
        guard let error = result.error, case LinkedListError.outOfBounds = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_updateOutOfUpperBound_shouldThrowError() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result(catching: { try list.update(1, at: 3) })
        guard let error = result.error, case LinkedListError.outOfBounds = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_removeOnEmptyList_shouldThrowError() {
        let list = LinkedListStorage<Int>()
        let result = Result(catching: { try list.remove(at: 0) })
        guard let error = result.error, case LinkedListError.empty = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_removeOutOfLowerBound_shouldThrowError() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result(catching: { try list.remove(at: -1) })
        guard let error = result.error, case LinkedListError.outOfBounds = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_removeOutOfUpperBound_shouldThrowError() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result(catching: { try list.remove(at: 3) })
        guard let error = result.error, case LinkedListError.outOfBounds = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
}
