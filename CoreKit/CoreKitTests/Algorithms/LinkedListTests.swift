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
    
    // MARK: Test Append Node
    
    func test_appendNodeToEmptyList_shouldEqualsHead() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.append(node: node)
        expect(list.head) === node
    }
    
    func test_appendNodeToEmptyList_shouldEqualsTail() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.append(node: node)
        expect(list.tail) === node
    }
    
    func test_appendNodeToEmptyList_shouldCounterBeIncremented() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.append(node: node)
        expect(list.count) == 1
    }
    
    func test_appendNodeToEmptyList_shouldContainElement() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.append(node: node)
        expect(Array(list.makeIterator())) == [1]
    }
    
    func test_appendNodeToNonEmptyList_shouldNotModifyHead() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.append(node: node)
        expect(list.head) !== node
    }
    
    func test_appendNodeToNonEmptyList_shouldEqualsTail() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.append(node: node)
        expect(list.tail) === node
    }
    
    func test_appendNodeToNonEmptyList_shouldCounterBeIncremented() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.append(node: node)
        expect(list.count) == 4
    }
    
    func test_appendNodeToNonEmptyList_shouldContainElement() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.append(node: node)
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    func test_appendAlreadyContainedNode_shouldFail() {
        
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result {
            if let head = list.head { try list.append(node: head) }
        }
        
        expect(result.isFailure) == true
        guard let error = result.error, case LinkedListError.nodeAlreadyLinked = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_appendContainedNodeFromOtherList_shouldCloneNode() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let other = LinkedListStorage<Int>([4])
        
        let result = Result {
            if let node = other.head { try list.append(node: node) }
        }
        
        expect(result.isSuccess) == true
        expect(list.tail) !== other.tail
        expect(list.tail?.value) == other.tail?.value
    }
    
    func test_appendContainedNodeFromOtherList_shouldContainElement() {
        let list = LinkedListStorage<Int>([1, 2, 3])
        let other = LinkedListStorage<Int>([4])
        
        let result = Result {
            if let node = other.head { try list.append(node: node) }
        }
        
        expect(result.isSuccess) == true
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    // MARK: Test Prepend Node
    
    func test_prependNodeToEmptyList_shouldEqualsHead() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.prepend(node: node)
        expect(list.head) === node
    }
    
    func test_prependNodeToEmptyList_shouldEqualsTail() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.prepend(node: node)
        expect(list.tail) === node
    }
    
    func test_prependNodeToEmptyList_shouldCounterBeIncremented() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.prepend(node: node)
        expect(list.count) == 1
    }
    
    func test_prependNodeToEmptyList_shouldContainElement() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>()
        try list.prepend(node: node)
        expect(Array(list.makeIterator())) == [1]
    }
    
    func test_prependNodeToNonEmptyList_shouldEqualsHead() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        try list.prepend(node: node)
        expect(list.head) === node
    }
    
    func test_prependNodeToNonEmptyList_shouldNotModifyTail() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        try list.prepend(node: node)
        expect(list.tail) !== node
    }
    
    func test_prependNodeToNonEmptyList_shouldCounterBeIncremented() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        try list.prepend(node: node)
        expect(list.count) == 4
    }
    
    func test_prependNodeToNonEmptyList_shouldContainElement() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        try list.prepend(node: node)
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    func test_prependAlreadyContainedNode_shouldFail() {
        
        let list = LinkedListStorage<Int>([1, 2, 3])
        let result = Result {
            if let head = list.head { try list.prepend(node: head) }
        }
        
        expect(result.isFailure) == true
        guard let error = result.error, case LinkedListError.nodeAlreadyLinked = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    func test_prependContainedNodeFromOtherList_shouldCloneNode() {
        let list = LinkedListStorage<Int>([2, 3, 4])
        let other = LinkedListStorage<Int>([1])
        
        let result = Result {
            if let node = other.head { try list.prepend(node: node) }
        }
        
        expect(result.isSuccess) == true
        expect(list.head) !== other.head
        expect(list.head?.value) == other.head?.value
    }
    
    func test_prependContainedNodeFromOtherList_shouldContainElement() {
        let list = LinkedListStorage<Int>([2, 3, 4])
        let other = LinkedListStorage<Int>([1])
        
        let result = Result {
            if let node = other.head { try list.prepend(node: node) }
        }
        
        expect(result.isSuccess) == true
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    // MARK: Test Insert Node After
    
    func test_insertNodeIntoOneElementListAfterHead_shouldUpdateTail() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>(1)
        if let head = list.head { try list.insert(node: node, after: head) }
        expect(list.tail) === node
    }
    
    func test_insertNodeIntoOneElementListAfterHead_shouldIncrementCounter() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>(1)
        if let head = list.head { try list.insert(node: node, after: head) }
        expect(list.count) == 2
    }
    
    func test_insertNodeIntoOneElementListAfterHead_shouldContainElement() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>(1)
        if let head = list.head { try list.insert(node: node, after: head) }
        expect(Array(list.makeIterator())) == [1, 2]
    }
    
    func test_insertNodeIntoOneElementListAfterTail_shouldUpdateTail() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>(1)
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        expect(list.tail) === node
    }
    
    func test_insertNodeIntoOneElementListAfterTail_shouldIncrementCounter() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>(1)
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        expect(list.count) == 2
    }
    
    func test_insertNodeIntoOneElementListAfterTail_shouldContainElement() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>(1)
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        expect(Array(list.makeIterator())) == [1, 2]
    }
    
    
    func test_insertNodeIntoNonEmptyListAfterHead_shouldNotUpdateTail() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>([1, 3, 4])
        let tail = list.tail
        if let head = list.head { try list.insert(node: node, after: head) }
        expect(list.tail) === tail
    }
    
    func test_insertNodeIntoNonEmptyListAfterHead_shouldIncrementCounter() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>([1, 3, 4])
        if let head = list.head { try list.insert(node: node, after: head) }
        expect(list.count) == 4
    }
    
    func test_insertNodeIntoNonEmptyListAfterHead_shouldContainElement() throws {
        let node = LinkedListNode(2)
        let list = LinkedListStorage<Int>([1, 3, 4])
        if let head = list.head { try list.insert(node: node, after: head) }
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    func test_insertNodeIntoNonEmptyListAfterTail_shouldUpdateTail() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        expect(list.tail) === node
    }
    
    func test_insertNodeIntoNonEmptyListAfterTail_shouldIncrementCounter() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        expect(list.count) == 4
    }
    
    func test_insertNodeIntoNonEmptyListAfterTail_shouldContainElement() throws {
        let node = LinkedListNode(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    // MARK: Test Insert Node Before
    
    func test_insertNodeIntoOneElementListBeforeHead_shouldUpdateHead() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>(2)
        if let head = list.head { try list.insert(node: node, before: head) }
        expect(list.head) === node
    }
    
    func test_insertNodeIntoOneElementListBeforeHead_shouldIncrementCounter() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>(2)
        if let head = list.head { try list.insert(node: node, before: head) }
        expect(list.count) == 2
    }
    
    func test_insertNodeIntoOneElementListBeforeHead_shouldContainElement() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>(2)
        if let head = list.head { try list.insert(node: node, before: head) }
        expect(Array(list.makeIterator())) == [1, 2]
    }
    
    func test_insertNodeIntoOneElementListBeforeTail_shouldUpdateHead() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>(2)
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        expect(list.head) === node
    }
    
    func test_insertNodeIntoOneElementListBeforeTail_shouldIncrementCounter() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>(2)
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        expect(list.count) == 2
    }
    
    func test_insertNodeIntoOneElementListBeforeTail_shouldContainElement() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>(2)
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        expect(Array(list.makeIterator())) == [1, 2]
    }
    
    func test_insertNodeIntoNonEmptyListBeforeHead_shouldUpdateHead() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        if let head = list.head { try list.insert(node: node, before: head) }
        expect(list.head) === node
    }
    
    func test_insertNodeIntoNonEmptyListBeforeHead_shouldIncrementCounter() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        if let head = list.head { try list.insert(node: node, before: head) }
        expect(list.count) == 4
    }
    
    func test_insertNodeIntoNonEmptyListBeforeHead_shouldContainElement() throws {
        let node = LinkedListNode(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        if let head = list.head { try list.insert(node: node, before: head) }
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    func test_insertNodeIntoNonEmptyListBeforeTail_shouldNotUpdateHead() throws {
        let node = LinkedListNode(3)
        let list = LinkedListStorage<Int>([1, 2, 4])
        let head = list.head
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        expect(list.head) === head
    }
    
    func test_insertNodeIntoNonEmptyListBeforeTail_shouldIncrementCounter() throws {
        let node = LinkedListNode(3)
        let list = LinkedListStorage<Int>([1, 2, 4])
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        expect(list.count) == 4
    }
    
    func test_insertNodeIntoNonEmptyListBeforeTail_shouldContainElement() throws {
        let node = LinkedListNode(3)
        let list = LinkedListStorage<Int>([1, 2, 4])
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        expect(Array(list.makeIterator())) == [1, 2, 3, 4]
    }
    
    // MARK: Test Remove First
    
    func test_removeFirstForNonEmptyList_shouldNotContainFirstElement() throws{
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeFirst()
        expect(Array(list.makeIterator())) == [2, 3]
    }
    
    func test_removeFirstForNonEmptyList_shouldDecrementCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeFirst()
        expect(list.count) == 2
    }
    
    func test_removeFirstForEmptyList_shouldFail() {
        let list = LinkedListStorage<Int>()
        let result = Result {
            try list.removeFirst()
        }
        expect(result.isFailure) == true
        guard let error = result.error, case LinkedListError.empty = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    // MARK: Test Remove Last
    
    func test_removeLastForNonEmptyList_shouldNotContainLastElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeLast()
        expect(Array(list.makeIterator())) == [1, 2]
    }
    
    func test_removeLastForNonEmptyList_shouldDecrementCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeLast()
        expect(list.count) == 2
    }
    
    func test_removeLastForEmptyList_shouldFail() {
        let list = LinkedListStorage<Int>()
        let result = Result {
            try list.removeLast()
        }
        expect(result.isFailure) == true
        guard let error = result.error, case LinkedListError.empty = error else {
            fail("Invalid error type: \(result)")
            return
        }
    }
    
    // MARK: Test Remove Node
    
    func test_removeNodeFromOneElementList_shouldResetHead() throws {
        let list = LinkedListStorage<Int>(1)
        if let node = list.head { try list.remove(node: node) }
        expect(list.head).to(beNil())
    }
    
    func test_removeNodeFromOneElementList_shouldResetTail() throws {
        let list = LinkedListStorage<Int>(1)
        if let node = list.head { try list.remove(node: node) }
        expect(list.tail).to(beNil())
    }
    
    func test_removeNodeFromOneElementList_shouldDecrementCounter() throws {
        let list = LinkedListStorage<Int>(1)
        if let node = list.head { try list.remove(node: node) }
        expect(list.count) == 0
    }
    
    func test_removeNodeFromOneElementList_shouldNotContainElement() throws {
        let list = LinkedListStorage<Int>(1)
        if let node = list.head { try list.remove(node: node) }
        expect(Array(list.makeIterator())) == []
    }
    
    func test_removeFirstNodeFromNonEmptyList_shouldUpdateHead() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        let head = list.head
        if let node = list.head { try list.remove(node: node) }
        expect(list.head) !== head
    }
    
    func test_removeFirstNodeFromNonEmptyList_shouldNotUpdateTail() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        let tail = list.tail
        if let node = list.head { try list.remove(node: node) }
        expect(list.tail) === tail
    }
    
    func test_removeFirstNodeFromNonEmptyList_shouldDecrementCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        if let node = list.head { try list.remove(node: node) }
        expect(list.count) == 3
    }
    
    func test_removeFirstNodeFromNonEmptyList_shouldNotContainElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        if let node = list.head { try list.remove(node: node) }
        expect(Array(list.makeIterator())) == [2, 3, 4]
    }
    
    func test_removeLastNodeFromNonEmptyList_shouldNotUpdateHead() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        let head = list.head
        if let node = list.tail { try list.remove(node: node) }
        expect(list.head) === head
    }
    
    func test_removeLastNodeFromNonEmptyList_shouldUpdateTail() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        let tail = list.tail
        if let node = list.tail { try list.remove(node: node) }
        expect(list.tail) !== tail
    }
    
    func test_removeLastNodeFromNonEmptyList_shouldDecrementCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        if let node = list.tail { try list.remove(node: node) }
        expect(list.count) == 3
    }
    
    func test_removeLastNodeFromNonEmptyList_shouldNotContainElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        if let node = list.tail { try list.remove(node: node) }
        expect(Array(list.makeIterator())) == [1, 2, 3]
    }
    
    func test_removeMiddleNodeFromNonEmptyList_shouldNotUpdateHead() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        let head = list.head
        if let node = list.head?.next { try list.remove(node: node) }
        expect(list.head) === head
    }
    
    func test_removeMiddleNodeFromNonEmptyList_shouldNotUpdateTail() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        let tail = list.tail
        if let node = list.head?.next { try list.remove(node: node) }
        expect(list.tail) === tail
    }
    
    func test_removeMiddleNodeFromNonEmptyList_shouldDecrementCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        if let node = list.head?.next { try list.remove(node: node) }
        expect(list.count) == 3
    }
    
    func test_removeMiddleNodeFromNonEmptyList_shouldNotContainElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4])
        if let node = list.head?.next { try list.remove(node: node) }
        expect(Array(list.makeIterator())) == [1, 3, 4]
    }
    
    // MARK: Test Remove All After
    
    func test_removeAllAfterHead_shouldContainOneElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.head { try list.removeAll(after: node) }
        expect(Array(list.makeIterator())) == [1]
    }
    
    func test_removeAllAfterTail_shouldContainAllElements() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.tail { try list.removeAll(after: node) }
        expect(Array(list.makeIterator())) == [1, 2, 3, 4, 5]
    }
    
    func test_removeAllAfterMiddleNode_shouldContainBeforeElements() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.head?.next?.next { try list.removeAll(after: node) }
        expect(Array(list.makeIterator())) == [1, 2, 3]
    }
    
    func test_removeAllAfterMiddleNode_shouldUpdateCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.head?.next?.next { try list.removeAll(after: node) }
        expect(list.count) == 3
    }
    
    // MARK: TestRemove All Before
    
    func test_removeAllBeforeHead_shouldContainAllElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.head { try list.removeAll(before: node) }
        expect(Array(list.makeIterator())) == [1, 2, 3, 4, 5]
    }
    
    func test_removeAllBeforeTail_shouldContainOneElement() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.tail { try list.removeAll(before: node) }
        expect(Array(list.makeIterator())) == [5]
    }
    
    func test_removeAllBeforeMiddleNode_shouldContainAfterElements() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.head?.next?.next { try list.removeAll(before: node) }
        expect(Array(list.makeIterator())) == [3, 4, 5]
    }
    
    func test_removeAllBeforeMiddleNode_shouldUpdateCounter() throws {
        let list = LinkedListStorage<Int>([1, 2, 3, 4, 5])
        if let node = list.head?.next?.next { try list.removeAll(before: node) }
        expect(list.count) == 3
    }
    
    // MARK: Test Element Operations
    
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

final class ForewardIteratorForNodeOperationTests: XCTestCase {
    
    // MARK: Test Append
    
    func test_appendToEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>()
        try list.append(node: node)
        assertOrder(list, toEquals: [1])
    }
    
    func test_appendToNonEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.append(node: node)
        assertOrder(list, toEquals: [1, 2, 3, 4])
    }
    
    // MARK: Test Prepend
    
    func test_prependToEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>()
        try list.prepend(node: node)
        assertOrder(list, toEquals: [1])
    }
    
    func test_prependToNonEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        try list.prepend(node: node)
        assertOrder(list, toEquals: [1, 2, 3, 4])
    }
    
    // MARK: Test Insert Before
    
    func test_insertNodeIntoOneElementListBeforeHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>(2)
        if let head = list.head { try list.insert(node: node, before: head) }
        assertOrder(list, toEquals: [1, 2])
    }
    
    func test_insertNodeIntoNonEmptyListBeforeHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        if let head = list.head { try list.insert(node: node, before: head) }
        assertOrder(list, toEquals: [1, 2, 3, 4])
    }
    
    func test_insertNodeIntoOneElementListBeforeTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>(2)
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        assertOrder(list, toEquals: [1, 2])
    }
    
    func test_insertNodeIntoNonEmptyListBeforeTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(3)
        let list = LinkedListStorage<Int>([1, 2, 4])
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        assertOrder(list, toEquals: [1, 2, 3, 4])
    }
    
    // MARK: Test Insert After
    
    func test_insertNodeIntoOneElementListAfterHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(2)
        let list = LinkedListStorage<Int>(1)
        if let head = list.head { try list.insert(node: node, after: head) }
        assertOrder(list, toEquals: [1, 2])
    }
    
    func test_insertNodeIntoNonEmptyListAfterHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(2)
        let list = LinkedListStorage<Int>([1, 3, 4])
        if let head = list.head { try list.insert(node: node, after: head) }
        assertOrder(list, toEquals: [1, 2, 3, 4])
    }
    
    func test_insertNodeIntoOneElementListAfterTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(2)
        let list = LinkedListStorage<Int>(1)
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        assertOrder(list, toEquals: [1, 2])
    }
    
    func test_insertNodeIntoNonEmptyListAfterTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        assertOrder(list, toEquals: [1, 2, 3, 4])
    }
    
    // MARK: Test Remove Fist
    
    func test_removeFirst_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeFirst()
        assertOrder(list, toEquals: [2, 3])
    }
    
    // MARK: Test Remove Last
    
    func test_removeLast_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeLast()
        assertOrder(list, toEquals: [1, 2])
    }
    
    // MARK: Test Remove
    
    func test_removeFirstNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let head = list.head { try list.remove(node: head) }
        assertOrder(list, toEquals: [2, 3])
    }
    
    func test_removeLastNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.remove(node: tail) }
        assertOrder(list, toEquals: [1, 2])
    }
    
    func test_removeMiddleNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head?.next { try list.remove(node: node) }
        assertOrder(list, toEquals: [1, 3])
    }
    
    // MARK: Test Remove All After
    
    func test_removeAllAfterFirstNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head { try list.removeAll(after: node) }
        assertOrder(list, toEquals: [1])
    }
    
    func test_removeAllAfterLastNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.tail { try list.removeAll(after: node) }
        assertOrder(list, toEquals: [1, 2, 3])
    }
    
    func test_removeAllAfterMiddleNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head?.next { try list.removeAll(after: node) }
        assertOrder(list, toEquals: [1, 2])
    }
    
    // MARK: Test Remove All Before
    
    func test_removeAllBeforeFirstNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head { try list.removeAll(before: node) }
        assertOrder(list, toEquals: [1, 2, 3])
    }
    
    func test_removeAllBeforeLastNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.tail { try list.removeAll(before: node) }
        assertOrder(list, toEquals: [3])
    }
    
    func test_removeAllBeforeMiddleNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head?.next { try list.removeAll(before: node) }
        assertOrder(list, toEquals: [2, 3])
    }
    
    // MARK: Private
    
    func assertOrder<T: Equatable>(_ list: LinkedListStorage<T>, toEquals order: [T], file: StaticString = #file, line: UInt = #line) {
        let elements = list.head.map { Array($0.makeForewardIterator()) } ?? []
        XCTAssertEqual(elements, order, file: file, line: line)
    }
}

final class BackwardIteratorForNodeOperationTests: XCTestCase {
    
    // MARK: Test Append
    
    func test_appendToEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>()
        try list.append(node: node)
        assertOrder(list, toEquals: [1])
    }
    
    func test_appendToNonEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.append(node: node)
        assertOrder(list, toEquals: [4, 3, 2, 1])
    }
    
    // MARK: Test Prepend
    
    func test_prependToEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>()
        try list.prepend(node: node)
        assertOrder(list, toEquals: [1])
    }
    
    func test_prependToNonEmptyList_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        try list.prepend(node: node)
        assertOrder(list, toEquals: [4, 3, 2, 1])
    }
    
    // MARK: Test Insert Before
    
    func test_insertNodeIntoOneElementListBeforeHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>(2)
        if let head = list.head { try list.insert(node: node, before: head) }
        assertOrder(list, toEquals: [2, 1])
    }
    
    func test_insertNodeIntoNonEmptyListBeforeHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>([2, 3, 4])
        if let head = list.head { try list.insert(node: node, before: head) }
        assertOrder(list, toEquals: [4, 3, 2, 1])
    }
    
    func test_insertNodeIntoOneElementListBeforeTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(1)
        let list = LinkedListStorage<Int>(2)
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        assertOrder(list, toEquals: [2, 1])
    }
    
    func test_insertNodeIntoNonEmptyListBeforeTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(3)
        let list = LinkedListStorage<Int>([1, 2, 4])
        if let tail = list.tail { try list.insert(node: node, before: tail) }
        assertOrder(list, toEquals: [4, 3, 2, 1])
    }
    
    // MARK: Test Insert After
    
    func test_insertNodeIntoOneElementListAfterHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(2)
        let list = LinkedListStorage<Int>(1)
        if let head = list.head { try list.insert(node: node, after: head) }
        assertOrder(list, toEquals: [2, 1])
    }
    
    func test_insertNodeIntoNonEmptyListAfterHead_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(2)
        let list = LinkedListStorage<Int>([1, 3, 4])
        if let head = list.head { try list.insert(node: node, after: head) }
        assertOrder(list, toEquals: [4, 3, 2, 1])
    }
    
    func test_insertNodeIntoOneElementListAfterTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(2)
        let list = LinkedListStorage<Int>(1)
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        assertOrder(list, toEquals: [2, 1])
    }
    
    func test_insertNodeIntoNonEmptyListAfterTail_shouldIterateWithValidOrder() throws {
        let node = LinkedListNode<Int>(4)
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.insert(node: node, after: tail) }
        assertOrder(list, toEquals: [4, 3, 2, 1])
    }
    
    // MARK: Test Remove Fist
    
    func test_removeFirst_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeFirst()
        assertOrder(list, toEquals: [3, 2])
    }
    
    // MARK: Test Remove Last
    
    func test_removeLast_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        try list.removeLast()
        assertOrder(list, toEquals: [2, 1])
    }
    
    // MARK: Test Remove
    
    func test_removeFirstNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let head = list.head { try list.remove(node: head) }
        assertOrder(list, toEquals: [3, 2])
    }
    
    func test_removeLastNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let tail = list.tail { try list.remove(node: tail) }
        assertOrder(list, toEquals: [2, 1])
    }
    
    func test_removeMiddleNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head?.next { try list.remove(node: node) }
        assertOrder(list, toEquals: [3, 1])
    }
    
    // MARK: Test Remove All After
    
    func test_removeAllAfterFirstNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head { try list.removeAll(after: node) }
        assertOrder(list, toEquals: [1])
    }
    
    func test_removeAllAfterLastNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.tail { try list.removeAll(after: node) }
        assertOrder(list, toEquals: [3, 2, 1])
    }
    
    func test_removeAllAfterMiddleNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head?.next { try list.removeAll(after: node) }
        assertOrder(list, toEquals: [2, 1])
    }
    
    // MARK: Test Remove All Before
    
    func test_removeAllBeforeFirstNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head { try list.removeAll(before: node) }
        assertOrder(list, toEquals: [3, 2, 1])
    }
    
    func test_removeAllBeforeLastNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.tail { try list.removeAll(before: node) }
        assertOrder(list, toEquals: [3])
    }
    
    func test_removeAllBeforeMiddleNode_shouldIterateWithValidOrder() throws {
        let list = LinkedListStorage<Int>([1, 2, 3])
        if let node = list.head?.next { try list.removeAll(before: node) }
        assertOrder(list, toEquals: [3, 2])
    }
    
    // MARK: Private
    
    func assertOrder<T: Equatable>(_ list: LinkedListStorage<T>, toEquals order: [T], file: StaticString = #file, line: UInt = #line) {
        let elements = list.tail.map { Array($0.makeBackwardIterator()) } ?? []
        XCTAssertEqual(elements, order, file: file, line: line)
    }

}
