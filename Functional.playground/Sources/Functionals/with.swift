import Foundation

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {    
    return try f(a)
}
