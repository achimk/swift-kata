//
//  Created by Joachim Kret on 30/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import CoreKit

final class PublishSubjectTests: XCTestCase {
    
    struct TestError: Error { }
    
    private var bag = DisposeBag()
    
    override func tearDown() {
        bag = DisposeBag()
    }
    
    func testNext() {
        
        var isNext: Bool = false
        var isCompleted: Bool = false
        var isError: Bool = false
        var isDisposed: Bool = false
        
        let subject = PublishSubject<Void>()
        
        subject.subscribe(onNext: {
            isNext = true
        }, onError: { _ in
            isError = true
        }, onCompleted: {
            isCompleted = true
        }, onDisposed: {
            isDisposed = true
        }).disposed(by: bag)
        
        subject.onNext(())
        
        expect(isNext) == true
        expect(isCompleted) == false
        expect(isError) == false
        expect(isDisposed) == false
    }
    
    func testCompleted() {
        
        var isNext: Bool = false
        var isCompleted: Bool = false
        var isError: Bool = false
        var isDisposed: Bool = false
        
        let subject = PublishSubject<Void>()
        
        subject.subscribe(onNext: {
            isNext = true
        }, onError: { _ in
            isError = true
        }, onCompleted: {
            isCompleted = true
        }, onDisposed: {
            isDisposed = true
        }).disposed(by: bag)
        
        subject.onCompleted()
        
        expect(isNext) == false
        expect(isCompleted) == true
        expect(isError) == false
        expect(isDisposed) == true
    }
    
    func testError() {
     
        var isNext: Bool = false
        var isCompleted: Bool = false
        var isError: Bool = false
        var isDisposed: Bool = false
        
        let subject = PublishSubject<Void>()
        
        subject.subscribe(onNext: {
            isNext = true
        }, onError: { _ in
            isError = true
        }, onCompleted: {
            isCompleted = true
        }, onDisposed: {
            isDisposed = true
        }).disposed(by: bag)
        
        subject.onError(TestError())
        
        expect(isNext) == false
        expect(isCompleted) == false
        expect(isError) == true
        expect(isDisposed) == true
    }
}
