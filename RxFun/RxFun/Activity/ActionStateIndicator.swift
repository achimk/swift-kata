//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

open class ActionStateIndicator<Action, Value>: ObservableConvertibleType {

    public typealias ActionState = (action: Action?, state: ActivityState<Value, Error>)
    
    private let dispatcher = PublishRelay<(Action, Bool)>()
    private let state = BehaviorRelay<ActionState>(value: (nil, .initial))
    private let bag = DisposeBag()
    
    public var current: ActionState { return state.value }
    
    public init(scheduler: SchedulerType = MainScheduler.instance,
                reducer: @escaping (Action) -> Single<Value>) {
        
        prepareReduce(scheduler: scheduler, reducer: reducer)
    }

    public func dispatch(_ action: Action, force: Bool = false) {
        dispatcher.accept((action, force))
    }
    
    public func asObservable() -> Observable<ActionState> {
        return state.asObservable()
    }
    
    private func prepareReduce(
        scheduler: SchedulerType,
        reducer: @escaping (Action) -> Single<Value>) {
        
        let request: Observable<(Action, Bool, ActionState)> = dispatcher
            .observeOn(scheduler)
            .map { [state] (action, force) in
                return (action, force, state.value)
            }.filter { (_, force, current) in
                force || !current.state.isLoading
            }.share(replay: 1)
        
        let onLoad = request.flatMap { (action, force, current) -> Observable<ActionState> in
            if force && current.state.isLoading { return .never() }
            return .just((action, .loading))
        }
        
        let onResult = request.flatMapLatest { (action, _, _) -> Observable<ActionState> in
            reducer(action)
                .asObservable()
                .map { (action, .success($0)) }
                .catchError { .just((action, .failure($0))) }
        }
        
        Observable
            .merge(onLoad, onResult)
            .subscribeOn(scheduler)
            .bind(to: state)
            .disposed(by: bag)
    }
}
