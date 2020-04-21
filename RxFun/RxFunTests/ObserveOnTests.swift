//
//  Created by Joachim Kret on 09/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import CoreKit

final class ObserveOnTests: XCTestCase {
    
    struct TestError: Error { }
    
    private let internalKey = DispatchSpecificKey<String>()
    private let backgroundKey = DispatchSpecificKey<String>()
    
    private lazy var internalQueue: DispatchQueue = prepareQueue(name: "internal", key: internalKey)
    private lazy var backgroundQueue: DispatchQueue = prepareQueue(name: "background", key: backgroundKey)
    
    private var bag = DisposeBag()
    
    override func tearDown() {
        bag = DisposeBag()
    }
    
    func testObserveOn() {
        
        var queueOrder: [String] = []
        
        waitUntil { [bag, internalQueue, internalKey, backgroundQueue, backgroundKey] (done) in
            
            Observable
                .just(1)
                .observeOn(SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal"))
                .do(onNext: { _ in
                    if let value = DispatchQueue.getSpecific(key: internalKey) {
                        queueOrder.append(value)
                    }
                })
                .observeOn(SerialDispatchQueueScheduler(queue: backgroundQueue, internalSerialQueueName: "background"))
                .do(onNext: { _ in
                    if let value = DispatchQueue.getSpecific(key: backgroundKey) {
                        queueOrder.append(value)
                    }
                })
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { _ in
                    expect(Thread.isMainThread) == true
                    done()
                })
                .disposed(by: bag)
        }
        
        expect(queueOrder) == [
            "internal",
            "background"
        ]
            
    }
    
    func testInnerQueue() {
        
        var queueOrder: [String] = []
        let source = createBackgroundJust(2)
        
        waitUntil { [bag, internalQueue, internalKey, backgroundKey] (done) in
            
            Observable
                .just(1)
                .observeOn(SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal"))
                .do(onNext: { _ in
                    if let value = DispatchQueue.getSpecific(key: internalKey) {
                        queueOrder.append(value)
                    }
                    if let value = DispatchQueue.getSpecific(key: backgroundKey) {
                        queueOrder.append(value)
                    }
                })
                .flatMap { _ in source }
                .do(onNext: { _ in
                    if let value = DispatchQueue.getSpecific(key: internalKey) {
                        queueOrder.append(value)
                    }
                    if let value = DispatchQueue.getSpecific(key: backgroundKey) {
                        queueOrder.append(value)
                    }
                })
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { _ in
                    expect(Thread.isMainThread) == true
                    done()
                })
                .disposed(by: bag)
        }
        
        expect(queueOrder) == [
            "internal",
            "background"
        ]
        
    }
    
    private func createBackgroundJust<T>(_ value: T) -> Observable<T> {
        return Observable.create { [backgroundQueue] (observer) in
            
            backgroundQueue.async {
                observer.onNext(value)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func prepareQueue(name: String, key: DispatchSpecificKey<String>) -> DispatchQueue {
        let queue = DispatchQueue(label: name)
        queue.setSpecific(key: key, value: name)
        return queue
    }
}
