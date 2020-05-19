//
//  Created by Joachim Kret on 19/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa

public class RxStore<Action, State>: ObservableConvertibleType {

    private let actionState: Observable<(Action, State)>
    private let state: BehaviorRelay<State>
    private let dispatcher = PublishRelay<Action>()
    private let bag = DisposeBag()
    
    public var current: State { return state.value }
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                initialState: State,
                reducer: @escaping (Action, State) -> State?) {
        
        self.state = .init(value: initialState)
        
        let makeScheduler = { scheduler.or(else: { MainScheduler() }) }
        
        actionState = dispatcher
            .flatMap { Observable.just($0).observeOn(makeScheduler()) }
            .compactMap { [state] (action) in reducer(action, state.value).map { (action, $0) } }
            .share()

        actionState
            .map { $0.1 }
            .bind(to: state)
            .disposed(by: bag)
    }
    
    public func addSideEffect(_ sideEffect: @escaping (Action, State) -> Single<Action>?) {
        actionState
            .compactMap(sideEffect)
            .flatMapLatest { $0.catchError { _ in .never() } }
            .bind(to: dispatcher)
            .disposed(by: bag)
    }
    
    public func dispatch(_ action: Action) {
        dispatcher.accept(action)
    }

    public func asObservable() -> Observable<State> {
        return state.asObservable()
    }
}
