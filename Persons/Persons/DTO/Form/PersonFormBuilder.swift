//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

struct PersonFormBuilder {
    
    private let defaults = PersonDefaults()
    private var change: PersonChange
    private var errors: PersonErrors
    
    init(_ form: PersonForm) {
        self.change = form.change
        self.errors = form.errors
    }
    
    init(person: UnvalidatedPerson? = nil, errors: [PersonValidationKey: PersonValidationError]? = nil) {
        change = PersonChange(
            name: person?.name,
            surname: person?.surname,
            age: person?.age)
        
        self.errors = .init(errorByField: errors ?? [:])
    }
    
    func set(name: String?) -> PersonFormBuilder {
        var builder = self
        builder.change = builder.change.updated(name: name)
        builder.errors.errorByField[.name] = PersonValidator.validatePerson(name: name).error
        return builder
    }
    
    func set(surname: String?) -> PersonFormBuilder {
        var builder = self
        builder.change = builder.change.updated(surname: surname)
        builder.errors.errorByField[.surname] = PersonValidator.validatePerson(surname: surname).error
        return builder
    }
    
    func set(age: UInt?) -> PersonFormBuilder {
        var builder = self
        builder.change = builder.change.updated(age: age)
        builder.errors.errorByField[.age] = PersonValidator.validatePerson(minimalAge: Person.minimalAge, age: age).error
        return builder
    }
    
    func build() -> PersonForm {
        return PersonForm(
            defaults: defaults,
            change: change,
            errors: errors)
    }
}
