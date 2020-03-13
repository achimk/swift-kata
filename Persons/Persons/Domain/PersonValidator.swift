//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation
import CoreKit

public enum PersonValidationKey: String {
    case name
    case surname
    case age
}

public enum PersonValidationError: Swift.Error {
    case isRequired
    case invalidAge(age: UInt, lessThan: UInt)
}

struct PersonValidator {
    
    static func validatePerson(name: String?) -> Result<String, PersonValidationError> {
        let value: String? = name.flatMap { value in
            if value.count > 0 { return value }
            else { return nil }
        }
        
        return value.map(Result.success) ?? .failure(.isRequired)
    }
    
    static func validatePerson(surname: String?) -> Result<String, PersonValidationError> {
        let value: String? = surname.flatMap { value in
            if value.count > 0 { return value }
            else { return nil }
        }
        
        return value.map(Result.success) ?? .failure(.isRequired)
    }
    
    static func validatePerson(minimalAge: UInt, age: UInt?) -> Result<UInt, PersonValidationError> {
        guard let age = age else { return .failure(.isRequired) }
        return age >= minimalAge  ? .success(age) : .failure(.invalidAge(age: age, lessThan: minimalAge))
    }
    
    static func validatePerson(_ unvalidated: UnvalidatedPerson) -> ValidatedResult<ValidatedPerson, [PersonValidationKey: PersonValidationError]> {
        
        let nameResult = validatePerson(name: unvalidated.name)
        let surnameResult = validatePerson(surname: unvalidated.surname)
        let ageResult = validatePerson(minimalAge: Person.minimalAge, age: unvalidated.age)
        
        do {
            let person = ValidatedPerson.init(
                name: try nameResult.get(),
                surname: try surnameResult.get(),
                age: try ageResult.get())
            
            return .valid(person)
            
        } catch {
            
            var errors: [PersonValidationKey: PersonValidationError] = [:]
            errors[.name] = nameResult.error
            errors[.surname] = surnameResult.error
            errors[.age] = ageResult.error
            
            return .invalid(errors)
        }
    }
    
}
