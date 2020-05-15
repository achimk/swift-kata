//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxFun

final class ActivityStateIndicatorTests: XCTestCase {
    
    struct TestError: Error, Equatable { }
    
    private let internalQueue = DispatchQueue(label: "internal", qos: .background)
    private lazy var internalSchedule: SchedulerType = {
        SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal")
    }()
    
    func test_initial_state() {
        let state = prepareTestActivityStateIndicator()
        expect(state.current.isInitial) == true
    }
    
    func test_loading_state() {
        let state = prepareTestActivityStateIndicator(shouldLoading: { true })
        state.dispatch()
        expect(state.current.isLoading) == true
    }
    
    func test_success_state() {
        let state = prepareTestActivityStateIndicator()
        state.dispatch()
        expect(state.current.isSuccess) == true
        state.current.onSuccess { (value) in
            expect(value) == 1
        }
    }
    
    func test_failure_state() {
        let state = prepareTestActivityStateIndicator(shouldFailure: { true })
        state.dispatch()
        expect(state.current.isFailure) == true
        state.current.onFailure { (error) in
            expect(error).to(beAKindOf(TestError.self))
        }
    }
    
    func test_multiple_states() {
        var shouldLoading = true
        var shouldFailure = false
        
        let state = prepareTestActivityStateIndicator(
            shouldLoading: { shouldLoading },
            shouldFailure: { shouldFailure })
        
        state.dispatch()
        expect(state.current.isLoading) == true
        
        shouldLoading = false
        shouldFailure = true
        
        state.dispatch(force: true)
        expect(state.current.isFailure) == true
        
        shouldLoading = false
        shouldFailure = false
        
        state.dispatch()
        expect(state.current.isSuccess) == true
    }
    
    func test_multipleDispatch_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var states: [String] = []
        var shouldLoading = true
        var shouldFailure = false
        
        let state = prepareTestActivityStateIndicator(
            shouldLoading: { shouldLoading },
            shouldFailure: { shouldFailure })
        state.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
            
        state.dispatch()
        expect(states) == [
            "initial",
            "loading"
        ]
        
        states = []
        shouldLoading = false
        shouldFailure = true
        
        state.dispatch(force: true)
        expect(states) == [
            "failure"
        ]
        
        states = []
        shouldLoading = false
        shouldFailure = false
        
        state.dispatch()
        expect(states) == [
            "loading",
            "success"
        ]
    }
    
    func test_dispatchDuringLoading_shouldIgnoreDispatch() {
        var call = 0
        let state = prepareTestActivityStateIndicator(shouldLoading: { call += 1; return true })
        state.dispatch()
        state.dispatch()
        expect(state.current.isLoading) == true
        expect(call) == 1
    }
    
    func test_dispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var isLoading = true
        var states: [String] = []
        
        let indicator = prepareTestActivityStateIndicator(shouldLoading: { isLoading })
        indicator.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
        
        indicator.dispatch()
        isLoading = false
        indicator.dispatch()
        
        expect(states) == [
            "initial",
            "loading"
        ]
    }
    
    func test_forceDispatchDuringLoading_shouldDispatch() {
        var call = 0
        let state = prepareTestActivityStateIndicator(shouldLoading: { call += 1; return true })
        state.dispatch()
        state.dispatch(force: true)
        expect(state.current.isLoading) == true
        expect(call) == 2
    }
    
    func test_forceDispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var isLoading = true
        var states: [String] = []
        
        let indicator = prepareTestActivityStateIndicator(shouldLoading: { isLoading })
        indicator.asObservable().subscribe(onNext: {
            states.append($0.stringValue)
        }).disposed(by: bag)
        
        indicator.dispatch()
        isLoading = false
        indicator.dispatch(force: true)
        
        expect(states) == [
            "initial",
            "loading",
            "success"
        ]
    }
    
    func test_dispatchInternalSchedule_shouldReturnOnMainSchedule() {

        let bag = DisposeBag()
        let state = prepareTestActivityStateIndicator(reduce: {
            expect(Thread.isMainThread) == true
            return Single.just(1)
        })

        waitUntil { [internalQueue] (done) in
            state.asObservable().subscribe(onNext: { state in
                if state.isSuccess {
                    expect(Thread.isMainThread) == true
                    done()
                }
            }).disposed(by: bag)

            internalQueue.async {
                expect(Thread.isMainThread) == false
                state.dispatch()
            }
        }
    }

    func test_reduceInternalSchedule_shouldReturnOnMainSchedule() {

        let bag = DisposeBag()
        let state = prepareTestActivityStateIndicator(reduce: { [internalSchedule] in
            expect(Thread.isMainThread) == true
            return Single
                .just(1)
                .observeOn(internalSchedule)
        })

        waitUntil { (done) in
            state.asObservable().subscribe(onNext: { state in
                if state.isSuccess {
                    expect(Thread.isMainThread) == true
                    done()
                }
            }).disposed(by: bag)

            state.dispatch()
        }
    }
    
    func test_dispatchAndReduceInternalSchedule_shouldReturnMainSchedule() {
        
        let bag = DisposeBag()
        let state = prepareTestActivityStateIndicator(reduce: { [internalSchedule] in
            expect(Thread.isMainThread) == true
            return Single
                .just(1)
                .observeOn(internalSchedule)
        })

        waitUntil { [internalQueue] (done) in
            state.asObservable().subscribe(onNext: { state in
                if state.isSuccess {
                    expect(Thread.isMainThread) == true
                    done()
                }
            }).disposed(by: bag)

            internalQueue.async {
                state.dispatch()
            }
        }
    }
    
    private func prepareTestActivityStateIndicator(
        scheduler: ImmediateSchedulerType? = nil,
        shouldLoading loadingOnAction: @escaping () -> Bool = { false },
        shouldFailure failureOnAction: @escaping () -> Bool = { false },
        reduce: @escaping () -> Single<Int> = { .just(1) }) -> ActivityStateIndicator<Int> {
        
        return ActivityStateIndicator(scheduler: scheduler) { () -> Single<Int> in
            if loadingOnAction() {
                return .never()
            }
            if failureOnAction() {
                return .error(TestError())
            }
            return reduce()
        }
    }
}
