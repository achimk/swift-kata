//: [Previous](@previous)

/*:
 
 4. Implement incremental changes

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
    
    private init(
        name: ValidatedResult<String, PersonValidationError>,
        email: ValidatedResult<String, PersonValidationError>,
        errors: [PersonField: PersonValidationError]) {
        
        self.name = name
        self.email = email
        self.errors = errors
        self.isValid = name.isValid && email.isValid
    }
    
    func validate(name value: String?) -> PersonValidation {
        
        let result = validatePerson(name: value)
        var errors = self.errors
        errors[.name] = result.error
        
        return PersonValidation(name: result, email: email, errors: errors)
    }
    
    func validate(email value: String?) -> PersonValidation {
        
        let result = validatePerson(email: value)
        var errors = self.errors
        errors[.email] = result.error
        
        return PersonValidation(name: name, email: result, errors: errors)
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
