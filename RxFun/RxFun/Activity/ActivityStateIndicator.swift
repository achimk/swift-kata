//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public final class ActivityStateIndicator<Value>: ObservableConvertibleType {
    
    public typealias State = ActivityState<Value, Error>
    public var current: State { return store.current }
    
    private let scheduler: ImmediateSchedulerType?
    private let sideEffect: () -> Single<Value>
    private lazy var store: RxStore<Action, State> = prepareStore()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                sideEffect: @escaping () -> Single<Value>) {
        
        self.scheduler = scheduler
        self.sideEffect = sideEffect
    }
    
    public func dispatch(force: Bool = false) {
        store.dispatch(.load(force))
    }
    
    public func asObservable() -> Observable<State> {
        return store.asObservable()
    }
}

extension ActivityStateIndicator {
    
    private enum Action {
        case load(Bool)
        case completed(Result<Value, Error>)
    }
    
    private func prepareStore() -> RxStore<Action, State> {
        
        let reducer: (Action, State) -> State? = { [weak self] (action, state) in
            return self?.reduce(action: action, state: state)
        }
        
        let onLoad: (Action, State) -> Single<Action>? = { [weak self] (action, state) in
            return self?.loadSideEffect(action: action, state: state)
        }
        
        let store = RxStore<Action, State>(
            scheduler: scheduler,
            initialState: .initial,
            reducer: reducer)
        
        store.addSideEffect(onLoad)
        
        return store
    }
    
    private func reduce(action: Action, state: State) -> State? {
        
        switch (action, state) {
        case (.load, .initial),
             (.load, .success),
             (.load, .failure):
            return .loading

        case (.load(let force), .loading):
            return force ? .loading : nil

        case (.completed(let result), .loading):
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(error)
            }

        default:
            return nil
        }
    }
    
    private func loadSideEffect(action: Action, state: State) -> Single<Action>? {
                    
        guard state.isLoading else {
            return nil
        }

        return sideEffect()
            .map(Result.success)
            .catchError { .just(.failure($0)) }
            .map(Action.completed)
    }
}
