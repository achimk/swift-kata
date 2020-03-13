//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift

struct GetPersonUseCase {
    
    let id: PersonId
    let repository: PersonRepository
    
    func prepare() -> Single<Person> {
        return repository.find(with: id).map { person in
            guard let person = person else {
                throw PersonError.notFound
            }
            return person
        }
    }
}
