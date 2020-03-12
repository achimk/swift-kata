import Foundation

public struct Pair<Left, Right> {
    public var left: Left
    public var right: Right
    
    public init(_ left: Left, _ right: Right) {
        self.left = left
        self.right = right
    }
}

extension Pair: Equatable where Left: Equatable, Right: Equatable { }
