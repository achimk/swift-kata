//
//  Created by Joachim Kret on 21/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    public func toResult() -> Observable<Result<Element, Error>> {
        return self.map(Result.success).catchError { .just(Result.failure($0)) }
    }
}
