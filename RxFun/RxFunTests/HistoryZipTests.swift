//
//  Created by Joachim Kret on 25/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import CoreKit

final class HistoryZipTests: XCTestCase {
    
    private var bag = DisposeBag()
    
    override func tearDown() {
        bag = DisposeBag()
    }
    
    func testMe() {
        
        let state = BehaviorRelay<Int>(value: 0)
        
        let shared = state.asObservable()
        
        var pairs: [Pair<Int, Int>] = []
        Observable.zip(shared, shared.skip(1))
            .subscribe(onNext: { data in
                let (old, new) = data
                pairs.append(Pair(old, new))
            })
            .disposed(by: bag)
        
        state.accept(1)
        state.accept(2)
        state.accept(3)
        
        pairs.forEach { print($0) }
    }
}
