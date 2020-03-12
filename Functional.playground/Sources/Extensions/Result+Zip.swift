import Foundation

extension Result {
    
    public func zip<U>(_ other: Result<U, Failure>) -> Result<(Success, U), Failure> {
        switch (self, other) {
        case (.failure(let error), _): return .failure(error)
        case (_, .failure(let error)): return .failure(error)
        case (.success(let l), .success(let r)): return .success((l, r))
        }
    }
}

extension Result {
    
    public static func zip<A, B> (
        _ a: Result<A, Failure>,
        _ b: Result<B, Failure>) -> Result<Success, Failure> where Success == (A, B) {
        
        return a.zip(b)
    }
    
    public static func zip<A, B, C>(
        _ a: Result<A, Failure>,
        _ b: Result<B, Failure>,
        _ c: Result<C, Failure>) -> Result<Success, Failure> where Success == (A, B, C) {
        
        let ab = Result<(A, B), Failure>.zip(a, b)
        return Result<((A, B), C), Failure>.zip(ab, c).map { ($0.0.0, $0.0.1, $0.1) }
    }
    
    public static func zip<A, B, C, D>(
        _ a: Result<A, Failure>,
        _ b: Result<B, Failure>,
        _ c: Result<C, Failure>,
        _ d: Result<D, Failure>) -> Result<Success, Failure> where Success == (A, B, C, D) {
        
        let ab = Result<(A, B), Failure>.zip(a, b)
        return Result<((A, B), C, D), Failure>.zip(ab, c, d).map { ($0.0.0, $0.0.1, $0.1, $0.2) }
    }
    
    public static func zip<A, B, C, D, E>(
        _ a: Result<A, Failure>,
        _ b: Result<B, Failure>,
        _ c: Result<C, Failure>,
        _ d: Result<D, Failure>,
        _ e: Result<E, Failure>) -> Result<Success, Failure> where Success == (A, B, C, D, E) {
        
        let ab = Result<(A, B), Failure>.zip(a, b)
        return Result<((A, B), C, D, E), Failure>.zip(ab, c, d, e).map { ($0.0.0, $0.0.1, $0.1, $0.2, $0.3) }
    }
    
    public static func zip<A, B, C, D, E, F>(
        _ a: Result<A, Failure>,
        _ b: Result<B, Failure>,
        _ c: Result<C, Failure>,
        _ d: Result<D, Failure>,
        _ e: Result<E, Failure>,
        _ f: Result<F, Failure>) -> Result<Success, Failure> where Success == (A, B, C, D, E, F) {
        
        let ab = Result<(A, B), Failure>.zip(a, b)
        return Result<((A, B), C, D, E, F), Failure>.zip(ab, c, d, e, f).map { ($0.0.0, $0.0.1, $0.1, $0.2, $0.3, $0.4) }
    }
    
    public static func zip<A, B, C, D, E, F, G>(
        _ a: Result<A, Failure>,
        _ b: Result<B, Failure>,
        _ c: Result<C, Failure>,
        _ d: Result<D, Failure>,
        _ e: Result<E, Failure>,
        _ f: Result<F, Failure>,
        _ g: Result<G, Failure>) -> Result<Success, Failure> where Success == (A, B, C, D, E, F, G) {
        
        let ab = Result<(A, B), Failure>.zip(a, b)
        return Result<((A, B), C, D, E, F, G), Failure>.zip(ab, c, d, e, f, g).map { ($0.0.0, $0.0.1, $0.1, $0.2, $0.3, $0.4, $0.5) }
    }
}
