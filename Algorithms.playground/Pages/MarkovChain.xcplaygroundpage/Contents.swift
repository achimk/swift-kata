//: [Previous](@previous)

import Foundation

// MARK: - Definitions -
public typealias Vector<T : Hashable> = [T : Int]

public typealias Matrix<T : Hashable> = [T : Vector<T>]

public enum DecisionProcess {
    case predict
    case random
    case weightedRandom
}

// MARK: - Type -
public struct MarkovModel<T : Hashable> {
    
// MARK: - Properties
    
    public private(set) var chain: Matrix<T>
    
// MARK: - Constructors
    
    /// - Complexity: O(n), where *n* is the length of the **transitions**.
    public init(transitions: [T]) {
        chain = transitions.makeTransitionsMatrix()
    }
    
    /// - Complexity: O(n), where *n* is the length of the **transitions**.
    public static func process(transitions: [T], completion: (Matrix<T>) -> Void) {
        completion(transitions.makeTransitionsMatrix())
    }
}

// MARK: - Matrix - Array
public extension Matrix where Value == Vector<Key> {
    
    /// - Complexity: O(n log n),  where *n* is the matrix's size
    public var uniqueStates: [Key] {
        var result = Set<Key>(keys)
        forEach { result.formUnion(Array($0.value.keys)) }
        return Array(result)
    }
    
    /// - Complexity: O(1), regardless the matrix's size.
    public func probabilities(given: Key) -> Vector<Key> {
        return self[given] ?? [:]
    }
    
    /// - Complexity: O(n), where *n* is the length of the possible transitions for the given **states**.
    public func next(given: Key, process: DecisionProcess = .predict) -> Key? {
        guard let values = self[given] else {
            return nil
        }
        
        let column = Array(values)
        
        switch process {
        case .predict:
            return values.max(by: { $0.value < $1.value })?.key
        case .random:
            return column.map({ $0.key }).randomElement
        case .weightedRandom:
            let probabilities = column.map { $0.value }
            return column[probabilities.weightedRandomIndex].key
        }
    }
}

// MARK: - Extension - Array
public extension Array where Element == IntegerLiteralType {
    
    /// - Complexity: O(n), where *n* is the count of this array.
    public var weightedRandomIndex: Index {
        
        let sum = reduce(0, +)
        let max = UInt32.max
        let random = Element(Float(sum) * Float(arc4random_uniform(max)) / Float(max))
        var accumulated = Element(0.0)
        let first = enumerated().first {
            accumulated += $1
            return random < accumulated
        }
        
        return first?.offset ?? count - 1
    }
}

// MARK: - Extension - Array
extension Array where Element : Hashable {
    
    /// - Complexity: O(1), regardless the matrix's size.
    var randomElement: Element? {
        
        if isEmpty { return nil }
        
        let index = Int(arc4random_uniform(UInt32(count)))
        
        return self[index]
    }
    
    /// - Complexity: O(n), where **n** is the total length of all transitions.
    func makeTransitionsMatrix() -> Matrix<Element> {
        
        var changesMatrix = Matrix<Element>()
        
        guard var old = first else {
            return changesMatrix
        }
        
        suffix(from: 1).forEach { nextValue in
            var chain = changesMatrix[old] ?? Vector<Element>()
            chain[nextValue] = 1 + (chain[nextValue] ?? 0)
            changesMatrix[old] = chain
            old = nextValue
        }
        
        return changesMatrix
    }
}

MarkovModel.process(transitions: [2, 4, 3, 2, 4, 1, 0, 4, 1]) { matrix in
    print(matrix)
    print(matrix.next(given: 4, process: .weightedRandom)!)
}

//let model = MarkovModel(transitions: ["A", "B", "A", "C"])
//print(model.chain)
//
//print(model.chain.next(given: "A")!)
//
//print(model.chain.next(given: "B")!)
//: [Next](@next)
