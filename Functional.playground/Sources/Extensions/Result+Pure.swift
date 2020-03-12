import Foundation

public func pure<T, E: Swift.Error>(_ x: T) -> Result<T, E> {
    return .success(x)
}
