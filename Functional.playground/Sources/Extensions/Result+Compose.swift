import Foundation

public func >-> <A, B, C, E: Swift.Error>(_ f: @escaping (A) -> Result<B, E>, _ g: @escaping (B) -> Result<C, E>) -> (A) -> Result<C, E> {
    return {
        f($0) >>- g
    }
}

public func <-< <A, B, C, E: Swift.Error>(f: @escaping (B) -> Result<C, E>, g: @escaping (A) -> Result<B, E>) -> (A) -> Result<C, E> {
    return {
        g($0) >>- f
    }
}
