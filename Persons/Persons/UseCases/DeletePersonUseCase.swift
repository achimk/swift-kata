//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift

struct DeletePersonUseCase {
    
    let id: PersonId
    let repository: PersonRepository
    
    func prepare() -> Single<Void> {
        return repository.remove(with: id)
    }
}

