import Foundation

extension Optional {
    
    public func ifPresent(_ action: (Wrapped) -> ()) {
        map { action($0) }
    }
    
    public var isPresent: Bool {
        return map { _ in true } ?? false
    }
}
