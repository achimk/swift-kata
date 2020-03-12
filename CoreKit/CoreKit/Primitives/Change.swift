import Foundation

public struct Change<T: Equatable> {
    
    public var original: T
    public var value: T
    public let isModified: Bool
    
    public init(_ value: T) {
        self.original = value
        self.value = value
        self.isModified = false
    }
    
    public init(original: T, value: T) {
        self.original = original
        self.value = value
        self.isModified = original != value
    }
    
    public func updated(_ value: T) -> Change<T> {
        return Change(original: original, value: value)
    }
}
