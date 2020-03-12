//: [Previous](@previous)

import Foundation

struct EmailValidationRule {
    
    let pattern = "^.+@.+\\..+$"
    
    func validate(_ value: String?) -> Bool {
        
        guard let value = value else { return false }
        
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: value)
    }
}

struct UnvalidatedEmailAddress {
    
    let value: String?
}

struct EmailAddress {
    
    let value: String
    
    init?(_ value: String?) {
        guard EmailValidationRule().validate(value) else { return nil }
        self.value = value!
    }
}

typealias EmailAddressValidator = (UnvalidatedEmailAddress) -> Result<EmailAddress, Never>

struct VerifiedEmail {
    
    let value: String
    
    init(_ emailAddress: EmailAddress) {
        self.value = emailAddress.value
    }
}

typealias VerificationHash = String

typealias VerificationService = (EmailAddress, VerificationHash) -> VerifiedEmail?

enum EmailContactInfo {
    
    case verified(VerifiedEmail)
    
    case unverified(EmailAddress)
}

typealias PostalContactInfo = String

enum ContactInfo {
    
    case emailOnly(EmailContactInfo)
    
    case addressOnly(PostalContactInfo)
    
    case emailAndAddress(EmailContactInfo, PostalContactInfo)
}

struct PersonalName {
    var firstName: String
    var lastName: String
    var middleInitial: String?
}

struct PersonalContact {
    var name: PersonalName
    var contact: ContactInfo
}



let personal = PersonalName(firstName: "Michael", lastName: "Jordan", middleInitial: nil)
let email = EmailAddress("michael.jordan@nba.com")!
let emailContact = EmailContactInfo.unverified(email)
let contact = ContactInfo.emailOnly(emailContact)
let personalContact = PersonalContact(name: personal, contact: contact)

print(personalContact)

//: [Next](@next)
