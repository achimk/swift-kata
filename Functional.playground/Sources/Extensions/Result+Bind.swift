import Foundation

public func >>- <A, B, E: Swift.Error>(_ x: Result<A, E>, _ f: (A) -> Result<B, E>) -> Result<B, E> {
    return x.flatMap(f)
}
public func -<< <A, B, E: Swift.Error>(_ f: (A) -> Result<B, E>, _ x: Result<A, E>) -> Result<B, E> {
    return x.flatMap(f)
}
