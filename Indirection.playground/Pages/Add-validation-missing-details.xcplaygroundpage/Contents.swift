//: [Previous](@previous)

/*:
 
 2. Add details for validation - is valid flag, errors container

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
    let name: String
    let email: String
    let errors: [PersonField: PersonValidationError]
    let isValid: Bool
}

struct PersonForm {
    let validation: PersonValidation
}


//: [Next](@next)
