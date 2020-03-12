//
// Optional + Unwrap
// Solution based on Dart implementation of Optional:
// https://pub.dev/documentation/optional/latest/optional_internal/Optional-class.html
//

import Foundation

extension Optional {
    
    public func or(else value: Wrapped) -> Wrapped {
        return self == nil ? value : self!
    }
    
    public func or(else action: () -> Wrapped) -> Wrapped {
        return self == nil ? action() : self!
    }
    
    public func or(else value: Optional<Wrapped>) -> Optional<Wrapped> {
        return self == nil ? value : self
    }
    
    public func or(else action: () -> Optional<Wrapped>) -> Optional<Wrapped> {
        return self == nil ? action() : self
    }
}


