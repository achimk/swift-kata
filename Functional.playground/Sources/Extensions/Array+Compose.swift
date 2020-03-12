import Foundation

public func >-> <A, B, C>(_ f: @escaping (A) -> [B], _ g: @escaping (B) -> [C]) -> (A) -> [C] {
    return {
        f($0) >>- g
    }
}

public func <-< <A, B, C>(_ f: @escaping (B) -> [C], _ g: @escaping (A) -> [B]) -> (A) -> [C] {
    return {
        g($0) >>- f
    }
}
