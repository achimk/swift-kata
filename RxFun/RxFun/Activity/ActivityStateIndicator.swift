//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public final class ActivityStateIndicator<Value>: ObservableConvertibleType {
 
    public typealias State = ActivityState<Value, Error>
    
    public var current: State { return state.value }
    
    private let dispatcher = PublishRelay<Bool>()
    private let state = BehaviorRelay<State>(value: .initial)
    private let bag = DisposeBag()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                reducer: @escaping () -> Single<Value>) {
        
        let schedulerFactory = { scheduler.or(else: { MainScheduler() }) }
        
        dispatcher
            .observeOn(schedulerFactory())
            .map { [state] (force) in
                return (force, state.value)
            }
            .filter { (force, state) in
                return force || !state.isLoading
            }
            .flatMapLatest { (_, state) -> Observable<State> in
                
                let start: Observable<State> = state.isLoading
                    ? .empty()
                    : .just(.loading)
                
                let result: Observable<State> = reducer()
                    .map(State.success)
                    .catchError { .just(State.failure($0)) }
                    .observeOn(schedulerFactory())
                    .asObservable()

                return Observable.concat(start, result)
            }
            .bind(to: state)
            .disposed(by: bag)
            
    }
    
    public func dispatch(force: Bool = false) {
        dispatcher.accept(force)
    }
    
    public func asObservable() -> Observable<State> {
        return state.asObservable()
    }
}
