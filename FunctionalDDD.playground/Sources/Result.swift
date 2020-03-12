import Foundation

public enum Result<Value, ErrorReason> {
    
    case success(Value)
    
    case failure(ErrorReason)
    
    public init(_ value: Value) {
        self = .success(value)
    }
    
    public init(_ errorReason: ErrorReason) {
        self = .failure(errorReason)
    }
}

extension Result {
    
    public var value: Value? { return analyze(ifSuccess: { $0 }, ifFailure: { _ in nil }) }
    
    public var errorReason: ErrorReason? { return analyze(ifSuccess: { _ in nil }, ifFailure: { $0 }) }
    
    public var isSuccess: Bool { return analyze(ifSuccess: { true }, ifFailure: { false }) }
    
    public var isFailure: Bool { return !isSuccess }
    
}

extension Result {
    
    public func map<U>(_ f: (Value) throws -> U) rethrows -> Result<U, ErrorReason> {
        return try flatMap { .success(try f($0)) }
    }
    
    public func flatMap<U>(_ f: (Value) throws -> Result<U, ErrorReason>) rethrows -> Result<U, ErrorReason> {
        
        return try analyze(
            ifSuccess: f,
            ifFailure: Result<U, ErrorReason>.failure
        )
    }
    
    public func mapError<U>(_ f: (ErrorReason) throws -> U) rethrows -> Result<Value, U> {
        return try flatMapError { .failure( try f($0)) }
    }
    
    public func flatMapError<U>(_ f: (ErrorReason) throws -> Result<Value, U>) rethrows -> Result<Value, U> {
        
        return try analyze(
            ifSuccess: Result<Value, U>.success,
            ifFailure: f
        )
    }
    
    public func onSuccess(_ perform: (Value) -> ()) {
        analyze(ifSuccess: perform, ifFailure: { _ in })
    }
    
    public func onFailure(_ perform: (ErrorReason) -> ()) {
        analyze(ifSuccess: { _ in }, ifFailure: perform)
    }
    
    public func analyze<T>(ifSuccess: () throws -> T, ifFailure: () throws -> T) rethrows -> T {
        switch self {
        case .success: return try ifSuccess()
        case .failure: return try ifFailure()
        }
    }
    
    public func analyze<T>(ifSuccess: (Value) throws -> T, ifFailure: (ErrorReason) throws -> T) rethrows -> T {
        switch self {
        case .success(let value): return try ifSuccess(value)
        case .failure(let error): return try ifFailure(error)
        }
    }
}

extension Result where Value == Void {
    
    public static func success() -> Result<Value, ErrorReason> {
        return Result.success(())
    }
}

extension Result where ErrorReason == Void {
    
    public static func failure() -> Result<Value, ErrorReason> {
        return Result.failure(())
    }
}

extension Result where ErrorReason == Swift.Error {
    
    public func determineValue() throws -> Value {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    public func throwsIfFailure() throws {
        switch self {
        case .success: return
        case .failure(let error): throw error
        }
    }
}

extension Result where ErrorReason: Swift.Error {
    
    public func determineValue() throws -> Value {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    public func throwsIfFailure() throws {
        switch self {
        case .success: return
        case .failure(let error): throw error
        }
    }
}

extension Result {
    
    public func asEither() -> Either<ErrorReason, Value> {
        
        return analyze(
            ifSuccess: Either<ErrorReason, Value>.right,
            ifFailure: Either<ErrorReason, Value>.left
        )
        
    }
}
