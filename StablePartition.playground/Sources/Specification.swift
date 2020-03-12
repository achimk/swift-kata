import Foundation

public protocol SatisfiableByCandidate {
    associatedtype Entity
    func isSatisfied(by candidate: Entity) -> Bool
}

public class Specification<T>: SatisfiableByCandidate {
    public typealias Entity = T
    
    public init() { }
    
    public func isSatisfied(by candidate: Entity) -> Bool {
        return false
    }
}

extension Specification {
    
    public func asSpecification() -> Specification<Entity> { return self }
}

extension Specification {
    
    public static func using(_ condition: @escaping ((Entity) -> Bool)) -> Specification<Entity> {
        return ConditionSpecification(condition)
    }
    
    public static func alwaysSatisfied() -> Specification<Entity> {
        return ConditionSpecification { _ in return true }
    }
    
    public static func neverSatisfied() -> Specification<Entity> {
        return ConditionSpecification { _ in return false }
    }
}

extension Specification {
    
    public func and(_ other: Specification<Entity>) -> Specification<Entity> {
        return ConditionSpecification { self.isSatisfied(by: $0) && other.isSatisfied(by: $0) }
    }
    
    public func or(_ other: Specification<Entity>) -> Specification<Entity> {
        return ConditionSpecification { self.isSatisfied(by: $0) || other.isSatisfied(by: $0) }
    }
    
    public func not() -> Specification<Entity> {
        return ConditionSpecification { !self.isSatisfied(by: $0) }
    }
}

public final class ConditionSpecification<T>: Specification<T> {
    let condition: ((Entity) -> Bool)
    
    public init(_ condition: @escaping ((Entity) -> Bool)) {
        self.condition = condition
    }
    
    public override func isSatisfied(by candidate: Entity) -> Bool {
        return condition(candidate)
    }
}
