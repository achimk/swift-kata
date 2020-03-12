//: [Previous](@previous)

import Foundation


struct UnvalidatedDocumentPayment {
    
    var id: String
    
    var amount: Double
    
    var reason: String?
}

enum DocumentPayment {
    
    case fullPayment(id: String)
    
    case partial(id: String, amount: Double, reason: String)
}

typealias DocumentPaymentForm = (UnvalidatedDocumentPayment) -> Result<DocumentPayment, Never>


//: [Next](@next)
