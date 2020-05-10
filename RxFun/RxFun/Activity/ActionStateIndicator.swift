//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

open class ActionStateIndicator<Action, Value>: ObservableConvertibleType {

    private let dispatcher = PublishRelay<(Action, Bool)>()
    private let state = BehaviorRelay<State>(value: .initial)
    private let bag = DisposeBag()
    
    public typealias State = ActivityState<Value, Swift.Error>
    public var current: State { return state.value }
    
    public init(scheduler: SchedulerType = MainScheduler.instance,
                reducer: @escaping (Action) -> Single<Value>) {
        
        prepareReduce(scheduler: scheduler, reducer: reducer)
    }

    public func dispatch(_ action: Action, force: Bool = false) {
        dispatcher.accept((action, force))
    }
    
    public func asObservable() -> Observable<State> {
        return state.asObservable()
    }
    
    private func prepareReduce(
        scheduler: SchedulerType,
        reducer: @escaping (Action) -> Single<Value>) {
        
        let request = dispatcher
            .observeOn(scheduler)
            .map { [state] (action, force) in
                return (action, force, state.value)
            }.filter { (_, force, state) in
                force || !state.isLoading
            }.share(replay: 1)
        
        let onLoad = request.flatMap { (_, force, state) -> Observable<State> in
            if force && state.isLoading { return .never() }
            return .just(.loading)
        }
        
        let onResult = request.flatMapLatest { (action, _, _) -> Observable<State> in
            reducer(action)
                .asObservable()
                .map { State.success($0) }
                .catchError { .just(State.failure($0)) }
        }
        
        Observable
            .merge(onLoad, onResult)
            .subscribeOn(scheduler)
            .bind(to: state)
            .disposed(by: bag)
    }
}
