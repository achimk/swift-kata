import Foundation

public struct AnyMonoid<T> {
    public let zero: T
    public let append: (T, T) -> T
}

extension AnyMonoid where T: Monoid {
    public init() {
        zero = T.zero
        append = T.reducer
    }
}
