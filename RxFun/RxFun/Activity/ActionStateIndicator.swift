//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public final class ActionStateIndicator<Action, Value>: ObservableConvertibleType {
 
    public typealias ActionState = (action: Action?, state: ActivityState<Value, Error>)
    
    public var current: ActionState { return state.value }
    
    private let dispatcher = PublishRelay<(Action, Bool)>()
    private let state = BehaviorRelay<ActionState>(value: (nil, .initial))
    private let bag = DisposeBag()
    
    public init(scheduler: ImmediateSchedulerType? = nil,
                reducer: @escaping (Action) -> Single<Value>) {
        
        let schedulerFactory = { scheduler.or(else: { MainScheduler() }) }
        
        dispatcher
            .observeOn(schedulerFactory())
            .map { [state] (action, force) in
                return (action, force, state.value)
            }
            .filter { (_, force, current) in
                return force || !current.state.isLoading
            }
            .flatMapLatest { (action, _, current) -> Observable<ActionState> in
                
                let start: Observable<ActionState> = current.state.isLoading
                    ? .empty()
                    : .just((action, .loading))
                
                let result: Observable<ActionState> = reducer(action)
                    .map { (action, .success($0)) }
                    .catchError { .just((action, .failure($0))) }
                    .observeOn(schedulerFactory())
                    .asObservable()

                return Observable.concat(start, result)
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
