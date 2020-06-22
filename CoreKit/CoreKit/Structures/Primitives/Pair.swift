import Foundation

public struct Pair<Left, Right> {
    public var left: Left
    public var right: Right
    
    public init(_ left: Left, _ right: Right) {
        self.left = left
        self.right = right
    }
}

extension Pair: Equatable where Left: Equatable, Right: Equatable {
    
    public static func ==(lhs: Pair<Left, Right>, rhs: Pair<Left, Right>) -> Bool {
        return lhs.left == rhs.left
            && lhs.right == rhs.right
    }
    
    public static func ==(lhs: Pair<Left, Right>, rhs: (Left, Right)) -> Bool {
        return lhs.left == rhs.0
            && lhs.right == rhs.1
    }
    
    public static func ==(lhs: (Left, Right), rhs: Pair<Left, Right>) -> Bool {
        return lhs.0 == rhs.left
            && lhs.1 == rhs.right
    }
}
