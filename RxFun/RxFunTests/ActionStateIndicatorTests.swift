//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxFun

final class ActionStateIndicatorTests: XCTestCase {
    
    struct TestError: Error, Equatable { }
    
    enum Action {
        case get
        case update
        case delete
    }
    
    private let internalQueue = DispatchQueue(label: "internal", qos: .background)
    private lazy var internalSchedule: SchedulerType = {
        SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal")
    }()
    
    func test_initial_state() {
        let indicator = prepareTestActionStateIndicator()
        expect(indicator.current.action.isPresent) == false
        expect(indicator.current.state.isInitial) == true
    }
    
    func test_loading_state() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { _ in true })
        indicator.dispatch(.get)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isLoading) == true
    }
    
    func test_success_state() {
        let indicator = prepareTestActionStateIndicator()
        indicator.dispatch(.get)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isSuccess) == true
        indicator.current.state.onSuccess { (value) in
            expect(value) == 1
        }
    }
    
    func test_failure_state() {
        let indicator = prepareTestActionStateIndicator(shouldFailure: { _ in true })
        indicator.dispatch(.get)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isFailure) == true
        indicator.current.state.onFailure { (error) in
            expect(error).to(beAKindOf(TestError.self))
        }
    }
    
    func test_dispatchDuringLoading_shouldIgnoreDispatch() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isLoading) == true
    }
    
    func test_forceDispatchDuringLoading_shouldDispatch() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        expect(indicator.current.action) == .update
        expect(indicator.current.state.isSuccess) == true
        indicator.current.state.onSuccess { (value) in
            expect(value) == 2
        }
    }
    
    func test_dispatchInternalSchedule_shouldReturnOnMainSchedule() {

        let bag = DisposeBag()
        let state = prepareTestActionStateIndicator(reduce: { _ in
            expect(Thread.isMainThread) == true
            return Single.just(1)
        })

        waitUntil { [internalQueue] (done) in
            state.asObservable().subscribe(onNext: { actionState in
                if actionState.state.isSuccess {
                    expect(Thread.isMainThread) == true
                    done()
                }
            }).disposed(by: bag)

            internalQueue.async {
                expect(Thread.isMainThread) == false
                state.dispatch(.get)
            }
        }
    }

    func test_reduceInternalSchedule_shouldReturnOnMainSchedule() {

        let bag = DisposeBag()
        let state = prepareTestActionStateIndicator(reduce: { [internalSchedule] _ in
            expect(Thread.isMainThread) == true
            return Single
                .just(1)
                .observeOn(internalSchedule)
        })

        waitUntil { (done) in
            state.asObservable().subscribe(onNext: { actionState in
                if actionState.state.isSuccess {
                    expect(Thread.isMainThread) == true
                    done()
                }
            }).disposed(by: bag)

            state.dispatch(.get)
        }
    }
    
    func test_dispatchAndReduceInternalSchedule_shouldReturnMainSchedule() {
        
        let bag = DisposeBag()
        let state = prepareTestActionStateIndicator(reduce: { [internalSchedule] _ in
            expect(Thread.isMainThread) == true
            return Single
                .just(1)
                .observeOn(internalSchedule)
        })

        waitUntil { [internalQueue] (done) in
            state.asObservable().subscribe(onNext: { actionState in
                if actionState.state.isSuccess {
                    expect(Thread.isMainThread) == true
                    done()
                }
            }).disposed(by: bag)

            internalQueue.async {
                state.dispatch(.get)
            }
        }
    }
    
    private func prepareTestActionStateIndicator(
        scheduler: ImmediateSchedulerType? = nil,
        shouldLoading loadingOnAction: @escaping (Action) -> Bool = { _ in false },
        shouldFailure failureOnAction: @escaping (Action) -> Bool = { _ in false },
        reduce: ((Action) -> Single<Int>)? = nil) -> ActionStateIndicator<Action, Int> {

        let reduce = reduce.or { (action) -> Single<Int> in
            switch action {
            case .get: return .just(1)
            case .update: return .just(2)
            case .delete: return .just(3)
            }
        }
        
        return ActionStateIndicator<Action, Int>(scheduler: scheduler) { (action) -> Single<Int> in
            if loadingOnAction(action) {
                return .never()
            }
            if failureOnAction(action) {
                return .error(TestError())
            }
            return reduce(action)
        }
    }
}
