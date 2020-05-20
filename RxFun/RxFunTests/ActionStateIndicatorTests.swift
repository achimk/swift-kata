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
    
    enum Action: Equatable {
        case get
        case update
        case delete
    }
    
    struct ActionState: Equatable {
        let action: Action?
        let state: String
        init(_ action: Action?, _ state: String) {
            self.action = action
            self.state = state
        }
    }
    
    private let internalQueue = DispatchQueue(label: "internal", qos: .background)
    private lazy var internalSchedule: SchedulerType = {
        SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal")
    }()
    
    func test_initial_state() {
        let indicator = prepareTestActionStateIndicator()
        expect(indicator.currentState.action.isPresent) == false
        expect(indicator.currentState.state.isInitial) == true
    }
    
    func test_loading_state() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { _ in true })
        indicator.dispatch(.get)
        expect(indicator.currentState.action) == .get
        expect(indicator.currentState.state.isLoading) == true
    }
    
    func test_success_state() {
        let indicator = prepareTestActionStateIndicator()
        indicator.dispatch(.get)
        expect(indicator.currentState.action) == .get
        expect(indicator.currentState.state.isSuccess) == true
        indicator.currentState.state.onSuccess { (value) in
            expect(value) == 1
        }
    }
    
    func test_failure_state() {
        let indicator = prepareTestActionStateIndicator(shouldFailure: { _ in true })
        indicator.dispatch(.get)
        expect(indicator.currentState.action) == .get
        expect(indicator.currentState.state.isFailure) == true
        indicator.currentState.state.onFailure { (error) in
            expect(error).to(beAKindOf(TestError.self))
        }
    }
    
    func test_multiple_states() {
        var shouldLoading = true
        var shouldFailure = false
        
        let indicator = prepareTestActionStateIndicator(
            shouldLoading: { _ in shouldLoading },
            shouldFailure: { _ in shouldFailure })
        
        indicator.dispatch(.get)
        expect(indicator.currentState.action) == .get
        expect(indicator.currentState.state.isLoading) == true
        
        shouldLoading = false
        shouldFailure = true
        
        indicator.dispatch(.update, force: true)
        expect(indicator.currentState.action) == .update
        expect(indicator.currentState.state.isFailure) == true
        
        shouldLoading = false
        shouldFailure = false
        
        indicator.dispatch(.delete)
        expect(indicator.currentState.action) == .delete
        expect(indicator.currentState.state.isSuccess) == true
    }
    
    func test_dispatchDuringLoading_shouldIgnoreDispatch() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update)
        expect(indicator.currentState.action) == .get
        expect(indicator.currentState.state.isLoading) == true
    }
    
    func test_dispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var actionStates: [ActionState] = []
        
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.asObservable().subscribe(onNext: {
            actionStates.append(ActionState($0.action, $0.state.stringValue))
        }).disposed(by: bag)
        
        indicator.dispatch(.get)
        indicator.dispatch(.update)
        
        expect(actionStates) == [
            .init(nil, "initial"),
            .init(.get, "loading")
        ]
    }
    
    func test_forceDispatchDuringLoading_shouldDispatch() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        expect(indicator.currentState.action) == .update
        expect(indicator.currentState.state.isSuccess) == true
        indicator.currentState.state.onSuccess { (value) in
            expect(value) == 2
        }
    }
    
    func test_forceDispatchDuringLoading_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var actionStates: [ActionState] = []
        
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.asObservable().subscribe(onNext: {
            actionStates.append(ActionState($0.action, $0.state.stringValue))
        }).disposed(by: bag)
        
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        
        expect(actionStates) == [
            .init(nil, "initial"),
            .init(.get, "loading"),
            .init(.update, "success")
        ]
    }
    
    func test_forceDispatchDuringLoadingWithoutSkipRepeats_shouldDispatchSequenceInOrder() {
        
        let bag = DisposeBag()
        var actionStates: [ActionState] = []
        
        let indicator = prepareTestActionStateIndicator(
            automaticallySkipsRepeats: false,
            shouldLoading: { $0 == .get })
        indicator.asObservable().subscribe(onNext: {
            actionStates.append(ActionState($0.action, $0.state.stringValue))
        }).disposed(by: bag)
        
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        
        expect(actionStates) == [
            .init(nil, "initial"),
            .init(.get, "loading"),
            .init(.update, "loading"),
            .init(.update, "success")
        ]
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
        automaticallySkipsRepeats skipsRepeats: Bool = true,
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
        
        return ActionStateIndicator<Action, Int>(
            scheduler: scheduler,
            automaticallySkipsRepeats: skipsRepeats,
            sideEffect: { (action) -> Single<Int> in
                if loadingOnAction(action) {
                    return .never()
                }
                if failureOnAction(action) {
                    return .error(TestError())
                }
                return reduce(action)
            })
    }
}
