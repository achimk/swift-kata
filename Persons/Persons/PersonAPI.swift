//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import CoreKit

public protocol PersonAPI: PersonFormAPI {
    
    // Quieries
    func person(with id: PersonId) -> Single<Person>
    func allPersons() -> Single<[Person]>
    func searchPersons(with parameters: PersonSearchParameters) -> Single<[Person]>
    
    // Commands
    func createPerson(form: PersonForm) -> Single<ValidatedResult<Person, PersonForm>>
    func updatePerson(with id: PersonId, form: PersonForm) -> Single<ValidatedResult<Person, PersonForm>>
    func deletePerson(with id: PersonId) -> Single<Void>
}
