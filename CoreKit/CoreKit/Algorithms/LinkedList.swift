//
//  Created by Joachim Kret on 08/06/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public enum LinkedListError: Error {
    case empty
    case outOfBounds
}

// MARK: - LinkedList

public struct LinkedList<T> {
    
    typealias Node = LinkedListStorage<T>.Node
    private var storage: LinkedListStorage<T>
    
    var head: Node? { return storage.head }
    var tail: Node? { return storage.tail }
    
    fileprivate init(_ storage: LinkedListStorage<T>) {
        self.storage = storage
    }
    
    public init() {
        storage = LinkedListStorage()
    }
    
    public init(_ element: T) {
        storage = LinkedListStorage(element)
    }
    
    public init(_ elements: T...) {
        storage = LinkedListStorage(elements)
    }
    
    public init(_ elements: [T]) {
        storage = LinkedListStorage(elements)
    }
}

// MARK: - LinkedList (Operations)

extension LinkedList {
    
    public mutating func append(_ element: T) {
        makeUnique()
        storage.append(element)
    }
    
    public mutating func insert(_ element: T, at index: Int) {
        makeUnique()
        try! storage.insert(element, at: index)
    }
    
    public mutating func update(_ element: T, at index: Int) {
        makeUnique()
        try! storage.update(element, at: index)
    }
    
    public mutating func remove(at index: Int) {
        makeUnique()
        try! storage.remove(at: index)
    }
    
    public mutating func removeAll() {
        makeUnique()
        storage.removeAll()
    }
}

// MARK: - LinkedList (Collection)

extension LinkedList: Collection {
    
    public var count: Int {
        return storage.count
    }
    
    public var startIndex: Int {
        return storage.startIndex
    }
    
    public var endIndex: Int {
        return storage.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return storage.index(after: i)
    }
    
    public subscript(position: Int) -> T {
        return storage[position]
    }
    
    public subscript(safe position: Int) -> T? {
        return storage[safe: position]
    }
}

extension LinkedList: RandomAccessCollection { }

// MARK: - LinkedList (Iterators)

extension LinkedList {
    
    public func makeForewardIterator() -> ForewardLinkedListIterator<T> {
        return ForewardLinkedListIterator(self)
    }
    
    public func makeBackwardIterator() -> BackwardLinkedListIterator<T> {
        return BackwardLinkedListIterator(self)
    }
}

// MARK: - LinkedList (Private)

extension LinkedList {

    private mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = storage.cloned()
        }
    }
}

// MARK: - ForewardLinkedListIterator

public struct ForewardLinkedListIterator<T>: IteratorProtocol, Sequence {
    
    private let list: LinkedList<T>
    private var node: LinkedList<T>.Node?
    
    public init(_ list: LinkedList<T>) {
        self.list = list
        self.node = list.head
    }
    
    public mutating func next() -> T? {
        let value = node?.value
        self.node = node?.next
        return value
    }
}

// MARK: - BackwardLinkedListIterator

public struct BackwardLinkedListIterator<T>: IteratorProtocol, Sequence {
    
    private let list: LinkedList<T>
    private var node: LinkedList<T>.Node?
    
    public init(_ list: LinkedList<T>) {
        self.list = list
        self.node = list.tail
    }
    
    public mutating func next() -> T? {
        let value = node?.value
        self.node = node?.previous
        return value
    }
}

// MARK: - LinkedListStorage (Container)

final class LinkedListStorage<T> {
    
    final class Node {
        var value: T
        var next: Node?
        weak var previous: Node?
        init(_ value: T) { self.value = value }
    }
    
    private(set) var counter: Int
    private(set) var head: Node?
    private(set) var tail: Node?
    
    init() {
        counter = 0
        head = nil
        tail = nil
    }
    
    init(_ element: T) {
        counter = 1
        let node = Node(element)
        head = node
        tail = node
    }
    
    init(_ elements: [T]) {
        counter = elements.count
        if let first = elements.first {
            let node = Node(first)
            head = node
            tail = node
            
            let list = Array(elements.dropFirst())
            list.forEach { (element) in
                let node = Node(element)
                tail?.next = node
                node.previous = tail
                tail = node
            }
        } else {
            head = nil
            tail = nil
        }
    }
}

extension LinkedListStorage {
    
    func append(_ element: T) {
        counter = counter.advanced(by: 1)
        let node = Node(element)
        if tail == nil {
            head = node
            tail = node
        } else {
            tail?.next = node
            node.previous = tail
            tail = node
        }
    }
    
    func insert(_ element: T, at index: Int) throws {
        try _insert(element, at: index, node: head)
    }
    
    private func _insert(_ element: T, at index: Int, node: Node?) throws {
        switch index {
        case 0:
            counter = counter.advanced(by: 1)
            let newNode = Node(element)
            let previous = node == nil ? tail : node?.previous
            let next = node
            
            newNode.previous = previous
            newNode.next = next
            next?.previous = newNode
            previous?.next = newNode
            
            if head == nil { head = newNode }
            else if head === next { head = newNode }
            if tail == nil { tail = newNode }
            else if tail === previous { tail = newNode }
        default:
            guard index > 0, index <= counter else { throw LinkedListError.outOfBounds }
            try _insert(element, at: index - 1, node: node?.next)
        }
    }
    
    func update(_ element: T, at index: Int) throws {
        try _update(element, at: index, node: head)
    }
    
    private func _update(_ element: T, at index: Int, node: Node?) throws {
        switch index {
        case 0:
            guard counter > 0 else { throw LinkedListError.empty }
            node?.value = element
        default:
            guard index > 0, index < counter else { throw LinkedListError.outOfBounds }
            try _update(element, at: index - 1, node: node?.next)
        }
    }
    
    func remove(at index: Int) throws {
        try _remove(at: index, node: head)
    }
    
    private func _remove(at index: Int, node: Node?) throws {
        switch index {
        case 0:
            guard counter > 0 else { throw LinkedListError.empty }
            counter = counter.advanced(by: -1)
            let previous = node?.previous
            let next = node?.next
            previous?.next = next
            next?.previous = previous
            if previous == nil { head = next }
            if next == nil { tail = previous }
        default:
            guard index > 0, index < counter else { throw LinkedListError.outOfBounds }
            try _remove(at: index - 1, node: node?.next)
        }
    }
    
    func removeAll() {
        counter = 0
        head = nil
        tail = nil
    }
}

extension LinkedListStorage: Collection {
    
    var count: Int {
        return counter
    }
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return count
    }
    
    func index(after i: Int) -> Int {
        return i.advanced(by: 1)
    }
    
    subscript(position: Int) -> T {
        return try! _value(at: position, node: head)
    }
    
    subscript(safe position: Int) -> T? {
        return try? _value(at: position, node: head)
    }
    
    private func _value(at position: Int, node: Node?) throws -> T {
        switch position {
        case 0:
            guard let node = node else {
                throw LinkedListError.empty
            }
            return node.value
        default:
            return try _value(at: position - 1, node: node?.next)
        }
    }
}

extension LinkedListStorage {
    
    func cloned() -> LinkedListStorage {
        return LinkedListStorage(Array(makeIterator()))
    }
}
