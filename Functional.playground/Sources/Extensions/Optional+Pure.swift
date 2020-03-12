import Foundation

public func pure<T>(_ x: T) -> T? {
    return .some(x)
}
