//
//  Created by Joachim Kret on 04/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation
import CoreKit
import RxSwift
import RxCocoa

final class OperationChain {
    
}

final class OperationStateObservable: ObservableConvertibleType {
    
    typealias State = ResultState<[Int], Error>
    
    private let state: ResultStateObservable<Void, [Int]>
    
    init() {
        state = .init(reducer: {
            return .just([1, 2, 3])
        })
    }
    
    func refresh() {
        state.dispatch()
    }

    func asObservable() -> Observable<State> {
        return state.asObservable()
    }
}


