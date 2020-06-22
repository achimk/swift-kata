//
//  Created by Joachim Kret on 08/06/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public enum LinkedListError: Error {
    case empty
    case outOfBounds
    case nodeNotLinked
    case nodeAlreadyLinked
}

// MARK: - Node

open class LinkedListNode<T> {
    fileprivate weak var parent: LinkedListStorage<T>?
    public var value: T
    public fileprivate(set) var next: LinkedListNode<T>?
    public fileprivate(set) weak var previous: LinkedListNode<T>?
    public init(_ value: T) { self.value = value }
}

// MARK: - Node (Iterators)

extension LinkedListNode {
    
    public func makeForewardIterator() -> ForewardNodeIterator<T> {
        return ForewardNodeIterator(self)
    }
    
    public func makeBackwardIterator() -> BackwardNodeIterator<T> {
        return BackwardNodeIterator(self)
    }
}

// MARK: - ForewardNodeIterator

public struct ForewardNodeIterator<T>: IteratorProtocol, Sequence {
    
    private var node: LinkedListNode<T>?
    
    public init(_ node: LinkedListNode<T>?) {
        self.node = node
    }
    
    public mutating func next() -> T? {
        let value = node?.value
        self.node = node?.next
        return value
    }
}

// MARK: - BackwardNodeIterator

public struct BackwardNodeIterator<T>: IteratorProtocol, Sequence {
    
    private var node: LinkedListNode<T>?
    
    public init(_ node: LinkedListNode<T>?) {
        self.node = node
    }
    
    public mutating func next() -> T? {
        let value = node?.value
        self.node = node?.previous
        return value
    }
}

// MARK: - LinkedList

public struct LinkedList<T> {
    
    public typealias Node = LinkedListNode<T>
    private var storage: LinkedListStorage<T>
    
    public var head: Node? { return storage.head }
    public var tail: Node? { return storage.tail }
    
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

// MARK: - LinkedList (Node Operations)

extension LinkedList {
    
    public mutating func append(node: Node) {
        makeUnique()
        try! storage.append(node: node)
    }
    
    public mutating func prepend(node: Node) {
        makeUnique()
        try! storage.prepend(node: node)
    }
    
    public mutating func insert(node: Node, after source: Node) {
        makeUnique()
        try! storage.insert(node: node, after: source)
    }
    
    public mutating func insert(node: Node, before source: Node) {
        makeUnique()
        try! storage.insert(node: node, before: source)
    }
    
    public mutating func remove(node: Node) {
        makeUnique()
        try! storage.remove(node: node)
    }
    
    public mutating func removeAll(after node: Node) {
        makeUnique()
        try! storage.removeAll(after: node)
    }
    
    public mutating func removeAll(before node: Node) {
        makeUnique()
        try! storage.removeAll(before: node)
    }
}

// MARK: - LinkedList (Element Operations)

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
    
    public func makeForewardIterator() -> ForewardNodeIterator<T> {
        return ForewardNodeIterator(head)
    }
    
    public func makeBackwardIterator() -> BackwardNodeIterator<T> {
        return BackwardNodeIterator(tail)
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

// MARK: - LinkedListStorage (Container)

final class LinkedListStorage<T> {

    typealias Node = LinkedListNode<T>

    private var counter: Int
    private(set) var head: Node?
    private(set) var tail: Node?
    
    init() {
        counter = 0
        head = nil
        tail = nil
    }
    
    init(_ element: T) {
        counter = 1
        let node = createNode(element)
        head = node
        tail = node
    }
    
    init(_ elements: [T]) {
        counter = elements.count
        if let first = elements.first {
            let node = createNode(first)
            head = node
            tail = node
            
            let list = Array(elements.dropFirst())
            list.forEach { (element) in
                let node = createNode(element)
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

// MARK: - LinkedListStorage (Node Operations)

extension LinkedListStorage {
    
    func append(node: Node) throws {
        try checkNodeNotAlreadyLinked(node)
        let node = cloneNodeIfNeeded(node)
        
        counter = counter.advanced(by: 1)
        node.parent = self
        
        if tail == nil {
            head = node
            tail = node
        } else {
            tail?.next = node
            node.previous = tail
            tail = node
        }
    }
    
    func prepend(node: Node) throws {
        try checkNodeNotAlreadyLinked(node)
        let node = cloneNodeIfNeeded(node)
        
        counter = counter.advanced(by: 1)
        node.parent = self
        
        if head == nil {
            head = node
            tail = node
        } else {
            head?.previous = node
            node.next = head
            head = node
        }
    }
    
    func insert(node: Node, after source: Node) throws {
        try checkNodeNotAlreadyLinked(node)
        try checkNodeLinked(source)
        
        counter = counter.advanced(by: 1)
        
        let next = source.next
        
        source.next = node
        node.previous = source
        node.next = next
        next?.previous = node
        node.parent = self
        
        if tail === source {
            tail = node
        }
    }
    
    func insert(node: Node, before source: Node) throws {
        try checkNodeNotAlreadyLinked(node)
        try checkNodeLinked(source)
        
        counter = counter.advanced(by: 1)
        
        let previous = source.previous
        
        source.previous = node
        node.next = source
        node.previous = previous
        previous?.next = node
        node.parent = self
        
        if head === source {
            head = node
        }
    }
    
    func remove(node: Node) throws {
        try checkNodeLinked(node)
        
        counter = count.advanced(by: -1)
        node.parent = nil
        
        let next = node.next
        let previous = node.previous
        
        previous?.next = next
        next?.previous = previous
        
        if head === node { head = next }
        if tail === node { tail = previous }
    }
    
    func removeAll(after node: Node) throws {
        try checkNodeLinked(node)
        
        var count = 0
        let it = ForewardNodeIterator(node.next)
        it.forEach { _ in count = count.advanced(by: 1) }
        
        counter = counter - count
        node.next = nil
        tail = node
    }
    
    func removeAll(before node: Node) throws {
        try checkNodeLinked(node)
        
        var count = 0
        let it = BackwardNodeIterator(node.previous)
        it.forEach { _ in count = count.advanced(by: 1) }
        
        counter = counter - count
        node.previous = nil
        head = node
    }
    
    private func checkNodeNotAlreadyLinked(_ node: Node) throws {
        if node.parent === self {
            throw LinkedListError.nodeAlreadyLinked
        }
    }
    
    private func checkNodeLinked(_ node: Node) throws {
        guard node.parent === self else {
            throw LinkedListError.nodeNotLinked
        }
    }
}

// MARK: - LinkedListStorage (Element Operations)

extension LinkedListStorage {
    
    func append(_ element: T) {
        counter = counter.advanced(by: 1)
        let node = createNode(element)
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
            let newNode = createNode(element)
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

// MARK: - LinkedListStorage (Collection)

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

// MARK: - LinkedListStorage (Private)

extension LinkedListStorage {
    
    fileprivate func createNode(_ value: T) -> Node {
        let node = Node(value)
        node.parent = self
        return node
    }
    
    fileprivate func cloneNodeIfNeeded(_ node: Node) -> Node {
        guard let parent = node.parent else {
            return node
        }
        if parent !== self {
            return createNode(node.value)
        } else {
            return node
        }
    }
    
    fileprivate func cloned() -> LinkedListStorage {
        return LinkedListStorage(Array(makeIterator()))
    }
}
