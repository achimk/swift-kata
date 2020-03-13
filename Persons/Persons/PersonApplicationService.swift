//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation
import RxSwift
import CoreKit

final class PersonApplicationService: PersonAPI {
    
    private let personRepository: PersonRepository
    
    init(personRepository: PersonRepository) {
        self.personRepository = personRepository
    }
    
    // MARK: - API
    
    func person(with id: PersonId) -> Single<Person> {
        return GetPersonUseCase(id: id, repository: personRepository).prepare()
    }
    
    func allPersons() -> Single<[Person]> {
        return AllPersonsUseCase(repository: personRepository).prepare()
    }
    
    func searchPersons(with parameters: PersonSearchParameters) -> Single<[Person]> {
        return SearchPersonsUseCase(search: parameters, repository: personRepository).prepare()
    }
    
    func createPerson(form: PersonForm) -> Single<ValidatedResult<Person, PersonForm>> {
        return CreatePersonUseCase(form: form, repository: personRepository).prepare()
    }
    
    func updatePerson(with id: PersonId, form: PersonForm) -> Single<ValidatedResult<Person, PersonForm>> {
        return UpdatePersonUseCase(id: id, form: form, repository: personRepository).prepare()
    }
    
    func deletePerson(with id: PersonId) -> Single<Void> {
        return DeletePersonUseCase(id: id, repository: personRepository).prepare()
    }
    
    // MARK: - Form

    func createPersonForm() -> PersonForm {
        return PersonFormBuilder().build()
    }
    
    func update(name: String?, for form: PersonForm) -> PersonForm {
        return PersonFormBuilder(form).set(name: name).build()
    }
    
    func update(surname: String?, for form: PersonForm) -> PersonForm {
        return PersonFormBuilder(form).set(surname: surname).build()
    }
    
    func update(age: UInt?, for form: PersonForm) -> PersonForm {
        return PersonFormBuilder(form).set(age: age).build()
    }
}
