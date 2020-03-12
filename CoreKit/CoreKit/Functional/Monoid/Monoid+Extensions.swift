import Foundation

extension String: Monoid {
    
    public static var zero: String {
        return ""
    }
    
    public func append(_ other: String) -> String {
        return self + other
    }
}

extension Int: Monoid {
    
    public static var zero: Int {
        return 0
    }
    
    public func append(_ other: Int) -> Int {
        return self + other
    }
}

extension Float: Monoid {
    
    public static var zero: Float {
        return 0
    }
    
    public func append(_ other: Float) -> Float {
        return self + other
    }
}

extension Double: Monoid {
    
    public static var zero: Double {
        return 0
    }
    
    public func append(_ other: Double) -> Double {
        return self + other
    }
}

extension Array: Monoid {
    
    public static var zero: Array<Element> {
        return []
    }
    
    public func append(_ other: Array<Element>) -> Array<Element> {
        var results = self
        results += other
        return results
    }
}

extension Set: Monoid {
    
    public static var zero: Set<Element> {
        return Set()
    }
    
    public func append(_ other: Set<Element>) -> Set<Element> {
        var results = self
        other.forEach { results.insert($0) }
        return results
    }
    
}
