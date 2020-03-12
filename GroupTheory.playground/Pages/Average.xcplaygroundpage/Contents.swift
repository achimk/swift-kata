//: [Previous](@previous)

import Foundation

precedencegroup PrecedenceLeft {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

infix operator <> :PrecedenceLeft

struct TwoSums {
    var a: Double
    var b: Double
}

extension TwoSums {
    func avg() -> Double {
        return a * 1.0 / b
    }
}

extension TwoSums {
    
    // Semigroup
    static func <>(lhs: TwoSums, rhs: TwoSums) -> TwoSums {
        return TwoSums(a: lhs.a + rhs.a, b: lhs.b + rhs.b)
    }
    
    // Monoid
    static var empty: TwoSums {
        return TwoSums(a: 0, b: 0)
    }
}

let sums = [
    TwoSums(a: 2, b: 1),
    TwoSums(a: 3, b: 2),
    TwoSums(a: 4, b: 1),
    TwoSums(a: 5, b: 3),
    TwoSums(a: 6, b: 1),
    TwoSums(a: 7, b: 4)
]

// Fold
let all = sums.reduce(TwoSums.empty, <>)

print("average:", all.avg())

//: [Next](@next)
