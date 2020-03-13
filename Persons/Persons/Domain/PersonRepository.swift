//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import CoreKit

public protocol PersonRepository {
    func all() -> Single<[Person]>
    func allSatisfying(_ specification: Specification<Person>) -> Single<[Person]>
    func find(with id: PersonId) -> Single<Person?>
    func add(person: ValidatedPerson) -> Single<Person>
    func update(with id: PersonId, person: ValidatedPerson) -> Single<Person>
    func remove(with id: PersonId) -> Single<Void>
}
