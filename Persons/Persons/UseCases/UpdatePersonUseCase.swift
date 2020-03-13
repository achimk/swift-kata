//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import CoreKit

struct UpdatePersonUseCase {
    
    let id: PersonId
    let form: PersonForm
    let repository: PersonRepository
    
    func prepare() -> Single<ValidatedResult<Person, PersonForm>> {
        
        let unvalidated = prepareUnvalidated(form)
        let validate = prepareValidation()
        let updateToRepository = prepareUpdateToRepository(repository, for: id)
        
        return Single
            .just(unvalidated)
            .map(validate)
            .flatMap(updateToRepository)
    }
    
    private func prepareUnvalidated(_ form: PersonForm) -> UnvalidatedPerson {
        return UnvalidatedPerson(
            name: form.change.name.value,
            surname: form.change.surname.value,
            age: form.change.age.value)
    }
    
    private func prepareValidation() -> (UnvalidatedPerson) -> (UnvalidatedPerson, ValidatedResult<ValidatedPerson, [PersonValidationKey: PersonValidationError]>) {
        return { unvalidated in
            return (unvalidated, PersonValidator.validatePerson(unvalidated))
        }
    }
    
    private func prepareUpdateToRepository(_ repository: PersonRepository, for id: PersonId) -> (_ unvalidated: UnvalidatedPerson, _ result: ValidatedResult<ValidatedPerson, [PersonValidationKey: PersonValidationError]>) -> Single<ValidatedResult<Person, PersonForm>> {
        
        return { (unvalidated, result) in
            
            switch result {
            case .valid(let person):
                return repository
                    .update(with: id, person: person)
                    .map(ValidatedResult.valid)
                
            case .invalid(let errors):
                let form = PersonFormBuilder(
                    person: unvalidated,
                    errors: errors).build()
                return Single
                    .just(form)
                    .map(ValidatedResult.invalid)
            }
        }
    }

}
