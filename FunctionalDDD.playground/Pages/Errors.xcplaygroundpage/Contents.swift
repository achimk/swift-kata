//: [Previous](@previous)

import Foundation

struct ValidationError {
    var field: String
    var errorReason: ErrorReason
}

protocol ErrorReason: Swift.Error {
    func accept(_ visitor: ErrorReasonVisitor)
}

protocol DomainErrorReason: Swift.Error { }

protocol ErrorReasonVisitor {
    func textInput(_ error: Errors.TextInput)
    func valueInput(_ error: Errors.ValueInput)
    func comparableInput<T: Comparable>(_ error: Errors.ComparableInput<T>)
    func domain(_ error: DomainErrorReason)
}

struct Errors {
    
    enum TextInput: ErrorReason {
        
        case isRequired
        case onlyDigits
        
        func accept(_ visitor: ErrorReasonVisitor) {
            visitor.textInput(self)
        }
    }
    
    enum ValueInput: ErrorReason {
        
        case isRequired
        
        func accept(_ visitor: ErrorReasonVisitor) {
            visitor.valueInput(self)
        }
    }
    
    enum ComparableInput<T: Comparable>: ErrorReason {
        
        case isRequired
        case isLess(than: T)
        case isGrater(than: T)
        
        func accept(_ visitor: ErrorReasonVisitor) {
            
        }
    }
    
    struct Domain: ErrorReason {
        
        var errorReason: DomainErrorReason
        
        init(_ errorReason: DomainErrorReason) {
            self.errorReason = errorReason
        }
        
        func accept(_ visitor: ErrorReasonVisitor) {
            visitor.domain(errorReason)
        }
    }
}

extension Errors.Domain {
    
    enum BusinessPartner: DomainErrorReason {
     
        case invalidBusinessPartner
    }
    
    enum Payment: DomainErrorReason {
        
        case invalidPayment
    }
}

struct PaymentLocalizer {
    
    var localizedInvalidPaymentError: String
}

class BaseErrorLocalizer: ErrorReasonVisitor {
    
    var localized: () -> String = { "Unexpected error!" }
 
    func localize(_ validationError: ValidationError) -> String {
        validationError.errorReason.accept(self)
        let message = localized()
        localized = { "Unexpected error!" }
        return message
    }
    
    func textInput(_ error: Errors.TextInput) {
        
    }
    
    func valueInput(_ error: Errors.ValueInput) {
        
    }
    
    func comparableInput<T>(_ error: Errors.ComparableInput<T>) where T : Comparable {
        
    }
    
    func domain(_ error: DomainErrorReason) {
        // Subclass should override domain error reasons!
        fatalError()
    }
}

class DomainErrorsLocalizer<T: DomainErrorReason>: BaseErrorLocalizer {
    
    override func domain(_ error: DomainErrorReason) {
        
        guard let typed = error as? T else { return }
        
        let message = localize(typed)
        
        localized = { message }
    }
    
    func localize(_ errorReason: T) -> String {
        // Subclass should override domain typed error reasons!
        fatalError()
    }
}

class PaymentErrorsLocalizer: DomainErrorsLocalizer<Errors.Domain.Payment> {
    
    override func localize(_ errorReason: Errors.Domain.Payment) -> String {
        
        switch errorReason {
        
        case .invalidPayment:
            return "Invalid payment!"
        }
    }
}

//: [Next](@next)
