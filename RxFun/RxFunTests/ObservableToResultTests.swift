//
//  Created by Joachim Kret on 21/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxFun

final class ObservableToResultTests: XCTestCase {
 
    func testObservable() {
        
        let publisher = PublishSubject<Int>()
        let observable = publisher.take(1).asObservable()
        
        observable.toResult()
        Observable.deferred(<#T##observableFactory: () throws -> Observable<_>##() throws -> Observable<_>#>)
    }
    
    func testSingle() {
        
        let publisher = PublishSubject<Int>()
        let single = publisher.take(1).asSingle()
        
        
    }
    
    func testCompletable() {
        
        let source: Completable = .empty()
        
        
    }
}
