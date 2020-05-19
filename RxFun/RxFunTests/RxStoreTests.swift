//
//  Created by Joachim Kret on 19/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxFun

final class RxStoreTests: XCTestCase {
    
    enum Action {
        
        // invoke reducer
        case ignored
        case reset
        case zero
        case increment
        case decrement
        
        // invoke side effect
        case requestSideEffectIgnore
        case requestSideEffectProcessing
        case requestSideEffectFailure
        case requestSideEffectIncrement
        case requestSideEffectDecrement
        case requestSideEffectInternalQueueZero
    }
    
    typealias State = Int
    
    private let internalQueue = DispatchQueue(label: "internal", qos: .background)
    private lazy var internalScheduler: SchedulerType = {
        SerialDispatchQueueScheduler(queue: internalQueue, internalSerialQueueName: "internal")
    }()
    
    func test_observeState_shouldNotifyInitialState() {
        
        var states: [State] = []
        let bag = DisposeBag()
        let store = prepareStore(initialState: 5)
        
        store.asObservable().subscribe(onNext: { state in
            states.append(state)
        }).disposed(by: bag)
        
        expect(states) == [5]
    }
    
    func test_observeState_whenDispachAction() {
        
        var states: [State] = []
        let bag = DisposeBag()
        let store = prepareStore(initialState: 0)
        
        store.asObservable().subscribe(onNext: { state in
            states.append(state)
        }).disposed(by: bag)
        
        store.dispatch(.increment)
        
        expect(states) == [0, 1]
    }
    
    func test_observeState_whenDispatchMultipleActions() {
        var states: [State] = []
        let bag = DisposeBag()
        let store = prepareStore(initialState: 3)
        
        store.asObservable().subscribe(onNext: { state in
            states.append(state)
        }).disposed(by: bag)
        
        store.dispatch(.increment)
        store.dispatch(.increment)
        store.dispatch(.reset)
        store.dispatch(.decrement)
        store.dispatch(.zero)
        
        expect(states) == [3, 4, 5, 3, 2, 0]
    }
    
    func test_observeState_whenDispatchIgnoredAction() {
        
        var states: [State] = []
        let bag = DisposeBag()
        let store = prepareStore(initialState: 5)
        
        store.asObservable().subscribe(onNext: { state in
            states.append(state)
        }).disposed(by: bag)
        
        store.dispatch(.ignored)
        
        expect(states) == [5]
    }
    
    func test_currentState_shouldNotifyInitialState() {
        
        let store = prepareStore(initialState: 5)
        
        expect(store.current) == 5
    }
    
    func test_currentState_whenDispatchAction() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.increment)
        
        expect(store.current) == 6
    }
    
    func test_currentState_whenDispatchMultipleActions() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.increment)
        store.dispatch(.increment)
        store.dispatch(.reset)
        store.dispatch(.decrement)
        store.dispatch(.zero)
        
        expect(store.current) == 0
    }
    
    func test_currentState_whenDispatchIgnoredAction() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.ignored)
        
        expect(store.current) == 5
    }
    
    func test_runSideEffect_shouldUpdateState() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.requestSideEffectIncrement)
        
        expect(store.current) == 6
    }
    
    func test_cancelSideEffect_shouldUpdateStateWithNewValue() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.requestSideEffectProcessing)
        store.dispatch(.requestSideEffectDecrement)
        
        expect(store.current) == 4
    }
    
    func test_ignoreSideEffect_shouldNotAffectState() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.requestSideEffectIgnore)
        
        expect(store.current) == 5
    }
    
    func test_failureSideEffect_shouldNotAffectState() {
        
        let store = prepareStore(initialState: 5)
        
        store.dispatch(.requestSideEffectFailure)
        
        expect(store.current) == 5
    }
    
    func test_dispatchInternalSchedule_shouldReturnOnMainSchedule() {
    
        var states: [State] = []
        var mainThread: [Bool] = []
        let bag = DisposeBag()
        let store = prepareStore(
            scheduler: MainScheduler.instance,
            internalScheduler: MainScheduler.instance,
            initialState: 5)
        
        waitUntil { [internalQueue] (done) in
            
            store.asObservable().subscribe(onNext: { state in
                mainThread.append(Thread.isMainThread)
                states.append(state)
                if state == 0 { done() }
            }).disposed(by: bag)
            
            internalQueue.async {
                store.dispatch(.requestSideEffectInternalQueueZero)
            }
        }
        
        expect(mainThread) == [true, true, true]
        expect(states) == [5, 5, 0]
    }
    
    func test_sideEffectInternalSchedule_shouldReturnOnMainSchedule() {
        
        var states: [State] = []
        var mainThread: [Bool] = []
        let bag = DisposeBag()
        let store = prepareStore(
            scheduler: MainScheduler.instance,
            internalScheduler: internalScheduler,
            initialState: 5)
        
        waitUntil { (done) in
            
            store.asObservable().subscribe(onNext: { state in
                mainThread.append(Thread.isMainThread)
                states.append(state)
                if state == 0 { done() }
            }).disposed(by: bag)
            
            store.dispatch(.requestSideEffectInternalQueueZero)
        }
        
        expect(mainThread) == [true, true, true]
        expect(states) == [5, 5, 0]
    }
    
    func test_dispatchAndSideEffectInternalSchedule_shouldReturnOnMainSchedule() {
        
        var states: [State] = []
        var mainThread: [Bool] = []
        let bag = DisposeBag()
        let store = prepareStore(
            scheduler: MainScheduler.instance,
            internalScheduler: internalScheduler,
            initialState: 5)
        
        waitUntil { [internalQueue] (done) in
            
            store.asObservable().subscribe(onNext: { state in
                mainThread.append(Thread.isMainThread)
                states.append(state)
                if state == 0 { done() }
            }).disposed(by: bag)
            
            internalQueue.async {
                store.dispatch(.requestSideEffectInternalQueueZero)
            }
        }
        
        expect(mainThread) == [true, true, true]
        expect(states) == [5, 5, 0]
    }
    
    private func prepareStore(
        scheduler: ImmediateSchedulerType? = nil,
        internalScheduler: ImmediateSchedulerType? = nil,
        initialState: State = 0) -> RxStore<Action, State> {
        
        let internalScheduler = internalScheduler ?? self.internalScheduler
        
        let reducer: (Action, State) -> State? = { (action, state) in
            switch action {
                
            // reduce actions
            case .ignored: return nil
            case .reset: return initialState
            case .zero: return 0
            case .increment: return state + 1
            case .decrement: return state - 1
                
            // side effect actions
            case .requestSideEffectIgnore,
                 .requestSideEffectProcessing,
                 .requestSideEffectFailure,
                 .requestSideEffectIncrement,
                 .requestSideEffectDecrement,
                 .requestSideEffectInternalQueueZero:
                return state
            }
        }
        
        let sideEffect: (Action, State) -> Single<Action>? = { (action, state) in
            switch action {
            case .requestSideEffectIgnore: return nil
            case .requestSideEffectProcessing: return .never()
            case .requestSideEffectFailure: return .error(NSError(domain: "test", code: 0, userInfo: nil))
            case .requestSideEffectIncrement: return .just(.increment)
            case .requestSideEffectDecrement: return .just(.decrement)
            case .requestSideEffectInternalQueueZero: return Single.just(.zero).observeOn(internalScheduler)
            default: return nil
            }
        }
        
        let store = RxStore(scheduler: scheduler, initialState: initialState, reducer: reducer)
        
        store.addSideEffect(sideEffect)
        
        return store
    }
}
