import Foundation

public struct Field<T> {
    public var value: T?
    public var error: Swift.Error?
    public var isActive: Bool
    public var isValid: Bool { return error == nil }
    public var isInvalid: Bool { return !isValid }
    public var isInactive: Bool { return !isActive }
    
    public init(
        value: T? = nil,
        error: Swift.Error? = nil,
        isActive: Bool = true) {
        
        self.value = value
        self.error = error
        self.isActive = isActive
    }
}
