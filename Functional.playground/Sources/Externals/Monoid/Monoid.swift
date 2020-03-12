import Foundation

public protocol Monoid {
    static var zero: Self { get }
    func append(_ other: Self) -> Self
}

extension Monoid {
    
    public mutating func append(_ other: Self) {
        self = self.append(other)
    }
    
    public static var reducer: (Self, Self) -> Self {
        return { x, y in x.append(y) }
    }
}
