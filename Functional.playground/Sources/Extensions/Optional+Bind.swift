import Foundation

public func >>- <A, B>(_ x: A?, _ f: @escaping (A) -> B?) -> B? {
    return x.flatMap(f)
}

public func -<< <A, B>(_ f: @escaping (A) -> B?, _ x: A?) -> B? {
    return x.flatMap(f)
}
