//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public final class ActivityStateIndicator<Value>: ObservableConvertibleType {
    
    public typealias State = ActivityState<Value, Error>
    public var currentState: State { return state.value }
    
    private let automaticallySkipsRepeats: Bool
    private let state = BehaviorRelay<State>(value: .initial)
    private let dispatcher = PublishRelay<Bool>()
    private let bag = DisposeBag()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                automaticallySkipsRepeats: Bool = true,
                sideEffect: @escaping () -> Single<Value>) {
        
        let makeScheduler = { scheduler.or(else: { MainScheduler() })}
        self.automaticallySkipsRepeats = automaticallySkipsRepeats
    
        dispatcher
            .observeOn(makeScheduler())
            .withLatestFrom(state) { ($0, $1) }
            .filter { (force, state) in force || !state.isLoading }
            .flatMapLatest { (force, state) -> Observable<State> in
                let loading = Observable
                    .just(State.loading)
                let completion = sideEffect()
                    .map(State.success)
                    .catchError { .just(State.failure($0)) }
                    .observeOn(makeScheduler())
                    .asObservable()
                return Observable.concat(loading, completion)
            }
            .bind(to: state)
            .disposed(by: bag)
    }
    
    public func dispatch(force: Bool = false) {
        dispatcher.accept(force)
    }
    
    public func asObservable() -> Observable<State> {
        return automaticallySkipsRepeats
            ? state.asObservable().distinctUntilChanged { (lhs, rhs) in lhs.stringValue == rhs.stringValue }
            : state.asObservable()
    }
}
