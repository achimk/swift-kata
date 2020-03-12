import Foundation

public indirect enum ResultState<Success, Failure> {
    case initial
    case loading
    case success(Success)
    case failure(Failure)
}

extension ResultState {
    
    public var isInitial: Bool {
        if case .initial = self { return true }
        else { return false }
    }
    
    public var isLoading: Bool {
        if case .loading = self { return true }
        else { return false }
    }
    
    public var isSuccess: Bool {
        if case .success = self { return true }
        else { return false }
    }
    
    public var isFailure: Bool {
        if case .failure = self { return true }
        else { return false }
    }
    
    public func onInitial(_ action: () -> ()) {
        if case .initial = self { action() }
    }
    
    public func onLoading(_ action: () -> ()) {
        if case .loading = self { action() }
    }
    
    public func onSuccess(_ action: (Success) -> ()) {
        if case .success(let value) = self { action(value) }
    }
    
    public func onFailure(_ action: (Failure) -> ()) {
        if case .failure(let error) = self { action(error) }
    }
}

extension ResultState {
    
    public var value: Success? {
        switch self {
        case .initial: return nil
        case .loading: return nil
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    public var error: Failure? {
        switch self {
        case .initial: return nil
        case .loading: return nil
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

extension ResultState where Failure: Swift.Error {
    
    public var result: Result<Success, Failure>? {
        switch self {
        case .initial: return nil
        case .loading: return nil
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(error)
        }
    }
}

extension ResultState: Equatable where Success: Equatable, Failure: Equatable {
    
    public static func ==(lhs: ResultState<Success, Failure>, rhs: ResultState<Success, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial): return true
        case (.loading, .loading): return true
        case let (.success(l), .success(r)): return l == r
        case let (.failure(l), .failure(r)): return l == r
        default: return false
        }
    }
}
