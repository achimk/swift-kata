import Foundation

extension Optional {
    
    public func ifPresent(_ action: (Wrapped) -> ()) {
        ifPresent(action, otherwise: { })
    }
    
    public func ifPresent(_ action: (Wrapped) -> (), otherwise: () -> ()) {
        switch self {
        case .none: otherwise()
        case .some(let value): action(value)
        }
    }
    
    public var isPresent: Bool {
        return map { _ in true } ?? false
    }
}
