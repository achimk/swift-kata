import Foundation

public enum ValidatedResult<Success, Failure> {
    case valid(Success)
    case invalid(Failure)
}

extension ValidatedResult {
    
    public var value: Success? {
        return analyze(valid: { $0 }, invalid: { _ in nil })
    }
    
    public var error: Failure? {
        return analyze(valid: { _ in nil }, invalid: { $0 })
    }
    
    public var isValid: Bool {
        return analyze(valid: { _ in true }, invalid: { _ in false })
    }
    
    public var isInvalid: Bool {
        return !isValid
    }
}

extension ValidatedResult {
    
    public func map<U>(_ f: (Success) -> U) -> ValidatedResult<U, Failure> {
        return flatMap { .valid(f($0)) }
    }
    
    public func flatMap<U>(_ f: (Success) -> ValidatedResult<U, Failure>) -> ValidatedResult<U, Failure> {
        return analyze(valid: f, invalid: ValidatedResult<U, Failure>.invalid)
    }
    
    public func mapError<U>(_ f: (Failure) -> U) -> ValidatedResult<Success, U> {
        return flatMapError { .invalid(f($0)) }
    }
    
    public func flatMapError<U>(_ f: (Failure) -> ValidatedResult<Success, U>) -> ValidatedResult<Success, U> {
        return analyze(valid: ValidatedResult<Success, U>.valid, invalid: f)
    }
    
    public func ifValid(_ action: (Success) -> ()) {
        analyze(valid: action, invalid: { _ in })
    }
    
    public func ifInvalid(_ action: (Failure) -> ()) {
        analyze(valid: { _ in }, invalid: action)
    }
    
    public func analyze<T>(valid: (Success) -> T, invalid: (Failure) -> T) -> T {
        switch self {
        case let .valid(value): return valid(value)
        case let .invalid(error): return invalid(error)
        }
    }
}

extension ValidatedResult where Failure: Swift.Error {
    
    public func asResult() -> Result<Success, Failure> {
        return analyze(
            valid: Result<Success, Failure>.success,
            invalid: Result<Success, Failure>.failure)
    }
    
    public func get() throws -> Success {
        switch self {
        case .valid(let value): return value
        case .invalid(let error): throw error
        }
    }
    
    public init(_ result: Result<Success, Failure>) {
        switch result {
        case .success(let value):
            self = .valid(value)
        case .failure(let error):
            self = .invalid(error)
        }
    }
}
