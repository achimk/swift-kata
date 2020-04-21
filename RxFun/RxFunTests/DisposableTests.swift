//
//  Created by Joachim Kret on 09/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import CoreKit

final class DisposableTests: XCTestCase {
    
    struct TestError: Error { }
    
    private var bag = DisposeBag()
    
    override func tearDown() {
        bag = DisposeBag()
    }
    
    func testDispose() {
        
        var results: [Int] = []
        var isError = false
        var isCompleted = false
        var isDisposed = false
        let publisher = PublishRelay<Int>()
        
        let disposable = publisher.subscribe(onNext: { value in
            results.append(value)
        }, onError: { error in
            isError = true
        }, onCompleted: {
            isCompleted = true
        }, onDisposed: {
            isDisposed = true
        })
        
        let dispose = { disposable.dispose() }
        
        publisher.accept(1)
        expect(results) == [1]
        
        publisher.accept(2)
        expect(results) == [1, 2]
        
        dispose()
        expect(isError) == false
        expect(isCompleted) == false
        expect(isDisposed) == true
        
        publisher.accept(3)
        expect(results) == [1, 2]
    }
}
