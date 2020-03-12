//: [Previous](@previous)

import Foundation

/*:
 
 3. Implement form is valid property

*/

enum PersonField: String {
    case name
    case email
}

enum PersonValidationError: Error {
    case isRequired
    case invalidEmail
}

struct PersonValidation {
    let name: ValidatedResult<String, PersonValidationError>
    let email: ValidatedResult<String, PersonValidationError>
    let errors: [PersonField: PersonValidationError]
    let isValid: Bool
    
    init(name: String?, email: String?) {
        
        let name = validatePerson(name: name)
        let email = validatePerson(email: email)
        
        self.name = name
        self.email = email
        self.errors = [:]
        self.isValid = name.isValid && email.isValid
    }
}

func validatePerson(name: String?) -> ValidatedResult<String, PersonValidationError> {
    return name.flatMap { $0.count > 0 ? .valid($0) : nil } ?? .invalid(.isRequired)
}

func validatePerson(email: String?) -> ValidatedResult<String, PersonValidationError> {
    return email.flatMap { $0.contains("@") ? .valid($0) : nil } ?? .invalid(.invalidEmail)
}

struct PersonForm {
    let validation: PersonValidation
}


//: [Next](@next)
