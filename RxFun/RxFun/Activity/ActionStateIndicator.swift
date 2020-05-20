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
    
    private let automaticallySkipsRepeats: Bool
    private let state = BehaviorRelay<ActionState>(value: (nil, .initial))
    private let dispatcher = PublishRelay<(Action, Bool)>()
    private let bag = DisposeBag()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                automaticallySkipsRepeats: Bool = true,
                sideEffect: @escaping (Action) -> Single<Value>) {
        
        let makeScheduler = { scheduler.or(else: { MainScheduler() })}
        self.automaticallySkipsRepeats = automaticallySkipsRepeats
        
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
        return automaticallySkipsRepeats
            ? state.asObservable().distinctUntilChanged { (lhs, rhs) in lhs.state.stringValue == rhs.state.stringValue }
            : state.asObservable()
    }
}
