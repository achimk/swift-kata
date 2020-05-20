//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public final class ActionStateIndicator<Action, Value>: ObservableConvertibleType {
    
    public typealias State = ActivityState<Value, Error>
    public typealias ActionState = (action: Action?, state: State)
    public var currentState: ActionState { return state.value }
    
    private let state = BehaviorRelay<ActionState>(value: (nil, .initial))
    private let dispatcher = PublishRelay<(Action, Bool)>()
    private let bag = DisposeBag()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                sideEffect: @escaping (Action) -> Single<Value>) {
        
        let makeScheduler = { scheduler.or(else: { MainScheduler() })}
        
        dispatcher
            .observeOn(makeScheduler())
            .withLatestFrom(state) { ($0.1, $0.0, $1.state) }
            .filter { (force, _, state) in force || !state.isLoading }
            .flatMapLatest { (_, action, state) -> Observable<ActionState> in
                let loading = Observable
                    .just((action: Optional(action), state: State.loading))
                let completion = sideEffect(action)
                    .map { (action: Optional(action), state: State.success($0)) }
                    .catchError { .just((action: Optional(action), state: State.failure($0))) }
                    .observeOn(makeScheduler())
                    .asObservable()
                return Observable
                    .concat(loading, completion)
            }
            .bind(to: state)
            .disposed(by: bag)
    }
    
    public func dispatch(_ action: Action, force: Bool = false) {
        dispatcher.accept((action, force))
    }
    
    public func asObservable() -> Observable<ActionState> {
        return state.asObservable()
    }
}


public final class ActionStateIndicatorX<Action, Value>: ObservableConvertibleType {
 
    public typealias ActionState = (action: Action?, state: ActivityState<Value, Error>)
    public var current: ActionState { return store.current }
    
    private let scheduler: ImmediateSchedulerType?
    private let sideEffect: (Action) -> Single<Value>
    private lazy var store: RxStore<Event, ActionState> = prepareStore()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                sideEffect: @escaping (Action) -> Single<Value>) {
        
        self.scheduler = scheduler
        self.sideEffect = sideEffect
    }
    
    public func dispatch(_ action: Action, force: Bool = false) {
        store.dispatch(.load(action, force))
    }
    
    public func asObservable() -> Observable<ActionState> {
        return store.asObservable()
    }
}

extension ActionStateIndicatorX {
    
    private enum Event {
        case load(Action, Bool)
        case completed(Action, Result<Value, Error>)
        var action: Action {
            switch self {
            case .load(let action, _): return action
            case .completed(let action, _): return action
            }
        }
    }
    
    private func prepareStore() -> RxStore<Event, ActionState> {
        
        let reducer: (Event, ActionState) -> ActionState? = { [weak self] (event, actionState) in
            self?.reduce(event: event, actionState: actionState)
        }
        
        let onLoad: (Event, ActionState) -> Single<Event>? = { [weak self] (event, actionState) in
            self?.loadSideEffect(event: event, actionState: actionState)
        }
        
        let store = RxStore<Event, ActionState>(
            scheduler: scheduler,
            initialState: (nil, .initial),
            reducer: reducer)
        
        store.addSideEffect(onLoad)
        
        return store
    }
    
    private func reduce(event: Event, actionState: ActionState) -> ActionState? {
        
        switch (event, actionState.state) {
        case (.load(let action, _), .initial),
             (.load(let action, _), .success),
             (.load(let action, _), .failure):
            return (action, .loading)

        case (.load(let action, let force), .loading):
            return force ? (action, .loading) : nil

        case (.completed(let action, let result), .loading):
            switch result {
            case .success(let value): return (action, .success(value))
            case .failure(let error): return (action, .failure(error))
            }

        default:
            return nil
        }
    }
    
    private func loadSideEffect(event: Event, actionState: ActionState) -> Single<Event>? {
        
        guard actionState.state.isLoading else {
            return nil
        }

        return sideEffect(event.action)
            .map(Result.success)
            .catchError { .just(.failure($0)) }
            .map { Event.completed(event.action, $0) }
    }
}
