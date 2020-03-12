import Foundation

public func >>- <T, U>(_ x: [T], _ f: @escaping (T) -> [U]) -> [U] {
    return x.flatMap(f)
}

public func -<< <T, U>(_ f: @escaping (T) -> [U], _ x: [T]) -> [U] {
    return x.flatMap(f)
}
