//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import CoreKit

struct SearchPersonsUseCase {
    
    let search: PersonSearchParameters
    let repository: PersonRepository
 
    func prepare() -> Single<[Person]> {
        // FIXME: Build search parameters specification here!
        let specification = Specification<Person>.alwaysSatisfied()
        return repository.allSatisfying(specification)
    }
}
