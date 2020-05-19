//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public final class ActivityStateIndicator<Value>: ObservableConvertibleType {
    
    enum Action {
        case load(Bool)
        case completed(Result<Value, Error>)
    }
    
    public typealias State = ActivityState<Value, Error>
    
    public var current: State { return state.current }
    
    private let state: ActionStateObservable<Action, State>
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                sideEffect makeSideEffect: @escaping () -> Single<Value>) {
        
        let reducer: (Action, State) -> State? = { (action, state) in
            
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
        
        let sideEffect: (Action, State) -> Single<Action>? = { (action, state) in
            
            guard state.isLoading else {
                return nil
            }
            
            return makeSideEffect()
                .map(Result.success)
                .catchError { .just(.failure($0)) }
                .map(Action.completed)
        }
        
        state = ActionStateObservable(
            scheduler: scheduler,
            initialState: .initial,
            reducer: reducer)
        
        state.add(sideEffect: sideEffect)
    }
    
    public func dispatch(force: Bool = false) {
        state.dispatch(.load(force))
    }
    
    public func asObservable() -> Observable<State> {
        return state.asObservable()
    }
}
