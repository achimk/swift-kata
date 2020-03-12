import Foundation

public func constant <A> (_ a : A) -> () -> A {
    return { a }
}

public func constant <A, B> (_ a : A) -> (B) -> A {
    return { _ in a }
}

public func constant <A, B, C> (_ a : A) -> (B, C) -> A {
    return { _, _ in a }
}

public func constant <A, B, C, D> (_ a : A) -> (B, C, D) -> A {
    return { _, _, _ in a }
}

public func constant <A, B, C, D, E> (_ a : A) -> (B, C, D, E) -> A {
    return { _, _, _, _ in a }
}
