import Foundation

// MARK: Compose Operator Right

public func <-< <A, B, C>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) -> B
    )
    -> (A) -> C {
        
        return { (a: A) -> C in
            f(g(a))
        }
}

public func <-< <A, B, C>(
    _ f: @escaping (B) throws -> C,
    _ g: @escaping (A) throws -> B
    )
    -> (A) throws -> C {
        
        return { (a: A) throws -> C in
            try f(g(a))
        }
}

// MARK: Compose Operator Left

public func >-> <A, B, C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C
    )
    -> (A) -> C {
        
        return { (a: A) -> C in
            g(f(a))
        }
}

public func >-> <A, B, C>(
    _ f: @escaping (A) throws -> B,
    _ g: @escaping (B) throws -> C
    )
    -> (A) throws -> C {
        
        return { (a: A) throws -> C in
            try g(f(a))
        }
}
