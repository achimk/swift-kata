//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift

struct AllPersonsUseCase {
    
    let repository: PersonRepository
    
    func prepare() -> Single<[Person]> {
        return repository.all()
    }
}
