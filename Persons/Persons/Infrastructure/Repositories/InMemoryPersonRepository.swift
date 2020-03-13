//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import CoreKit

final class InMemoryPersonRepository: PersonRepository {

    private var list: [Person]
    private let idGenerator: () -> String
    
    init(list: [Person] = [], idGenerator: @escaping () -> String = { UUID().uuidString }) {
        self.list = list
        self.idGenerator = idGenerator
    }
    
    func all() -> Single<[Person]> {
        fatalError("Implement!")
    }
    
    func allSatisfying(_ specification: Specification<Person>) -> Single<[Person]> {
        fatalError("Implement!")
    }
    
    func find(with id: PersonId) -> Single<Person?> {
        fatalError("Implement!")
    }
    
    func add(person: ValidatedPerson) -> Single<Person> {
        fatalError("Implement!")
    }
    
    func update(with id: PersonId, person: ValidatedPerson) -> Single<Person> {
        fatalError("Implement!")
    }
    
    func remove(with id: PersonId) -> Single<Void> {
        fatalError("Implement!")
    }
    
}
