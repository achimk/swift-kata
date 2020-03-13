//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public protocol Specifying {
    associatedtype Candidate
    func isSatisfied(by candidate: Candidate) -> Bool
}

extension Specifying {
    
    public func asSpecification() -> Specification<Candidate> {
        return Specification.from { self.isSatisfied(by: $0) }
    }
}

open class Specification<T>: Specifying {
    public typealias Candidate = T
    
    public init() { }
    
    open func isSatisfied(by candidate: Candidate) -> Bool {
        fatalError("Subclasses should override `isSatisfied(by:)` method!")
    }
}

extension Specification {
    
    public static func from(_ condition: @escaping ((Candidate) -> Bool)) -> Specification<Candidate> {
        return ConditionSpecification(condition)
    }
    
    public static func alwaysSatisfied() -> Specification<Candidate> {
        return ConditionSpecification { _ in return true }
    }
    
    public static func neverSatisfied() -> Specification<Candidate> {
        return ConditionSpecification { _ in return false }
    }
}

extension Specification {
    
    public func and(_ other: Specification<Candidate>) -> Specification<Candidate> {
        return ConditionSpecification { self.isSatisfied(by: $0) && other.isSatisfied(by: $0) }
    }
    
    public func or(_ other: Specification<Candidate>) -> Specification<Candidate> {
        return ConditionSpecification { self.isSatisfied(by: $0) || other.isSatisfied(by: $0) }
    }
    
    public func not() -> Specification<Candidate> {
        return ConditionSpecification { !self.isSatisfied(by: $0) }
    }
}

public final class ConditionSpecification<T>: Specification<T> {
    let condition: ((Candidate) -> Bool)
    
    public init(_ condition: @escaping ((Candidate) -> Bool)) {
        self.condition = condition
    }
    
    public override func isSatisfied(by candidate: Candidate) -> Bool {
        return condition(candidate)
    }
}
