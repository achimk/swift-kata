import Foundation

public func |> <A, B>(_ x: A, f: (A) -> B) -> B {
    return f(x)
}

public func |> <A, B>(_ x: A, _ f: (A) throws -> B) throws -> B {
    return try f(x)
}
