//: [Previous](@previous)

import Foundation

/*:
 
 ![Group Theory](operations.png)
 
*/

precedencegroup PrecedenceLeft {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

infix operator <> :PrecedenceLeft

// MARK: - Closed Binary Operators
// Power: Composable Operation
// Law: x <> y = z

protocol Magma {
    func op(_ other: Self) -> Self
}

func <> <M: Magma>(lhs: M, rhs: M) -> M {
    return lhs.op(rhs)
}

struct Sum: Magma {
    var value: Int
    func op(_ other: Sum) -> Sum {
        return Sum(value: value + other.value)
    }
}

print("Magma:", Sum(value: 1) <> Sum(value: 2))

// MARK: - Associativity
// Power: Freedom to chunk work, Paralellization is safe
// Magma + Associativity = Semigroup
// Law: (x <> y) <> z = x <> (y <> z)

protocol Semigroup: Magma {
//    static func <> (lhs: Self, rhs: Self) -> Self
}

extension Sum: Semigroup {
}

let a = Sum(value: 1) <> Sum(value: 2) // thread 1
let b = Sum(value: 3) <> Sum(value: 4) // thread 2
let all = a <> b
print("Semigroup:", all)

// MARK: - Identity
// Power: Drop the optional
// Associativity + Identity = Monoid
// Law: empty <> x = x
//      x <> empty = x

protocol Monoid: Semigroup {
    static var empty: Self { get }
}

extension Sum: Monoid {
    static var empty: Sum {
        return Sum(value: 0)
    }
}

print("Monoid:", Sum.empty <> Sum(value: 1))

// MARK: - Commutativity
// Power: Operations can be reordered (can show incremental result)
// Associativity + Identity + Commutativity = Commutative Monoid
// Law: x <> y = y <> x

protocol CommutativeMonoid: Monoid {
    
}

// MARK: - Idempotence
// Description: doing something twice is the same doing something once
// Power: No need for memory
// Associativity + Identity + Commutativity + Idempotence = Bounded Semilattice
// Law: x <> x <> y = y <> x

protocol BoundedSemilattice: CommutativeMonoid {
    
}

struct Max {
    var value: Int
}

extension Max: BoundedSemilattice {
    static var empty: Max { return Max.init(value: Int.min) }
    func op(_ other: Max) -> Max {
        return Max(value: max(value, other.value))
    }
}



//: [Next](@next)
