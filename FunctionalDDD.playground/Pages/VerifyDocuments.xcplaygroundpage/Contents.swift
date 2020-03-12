//: [Previous](@previous)

import Foundation

enum DocumentType {
    
    case passport
    
    case drivingLicence
    
    case idCard
    
    static var `default`: DocumentType {
        return .idCard
    }
}

enum DocumentSide {
    
    case front
    
    case back
}

enum VerificationKind {
    
    case document(DocumentSide)

    case selfie
}

struct VerificationRequirements {
    
    struct Flow {
        let kind: VerificationKind
        let next: Flow?
    }
    
    let documentType: DocumentType
    let verificationFlow: Flow
}



/**
 High order flow for document verification:
 -> starts with unverified document
 -> apply changes to unverified document (Front photo, Back photo etc...)
 -> apply changes until change state to verification ready document
 -> send document to verification
 -> on verification success -> VerifiedDocument
 -> on failure -> should we break?
 */

struct Photo {
    // specified data for photo
}

struct UnverifiedDocument {
    var documentType: DocumentType?
}

struct VerificationReadyDocument {
    let documentType: DocumentType
}

struct VerifiedDocument {
    let documentType: DocumentType
}

enum VerificationResult {
    
    case success
    
    case failure
    
    case expired
}

//: [Next](@next)
