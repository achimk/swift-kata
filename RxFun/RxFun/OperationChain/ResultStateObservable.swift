//
//  Created by Joachim Kret on 04/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

open class ResultStateObservable<Request, Response>: ObservableConvertibleType {

    public typealias State = ResultState<Response, Swift.Error>
    
    private let dispatcher = PublishRelay<(Request, Bool)>()
    private let state = BehaviorRelay<State>(value: .initial)
    private var bag = DisposeBag()
    
    public var current: State { return state.value }
    
    public init(scheduler: SchedulerType = MainScheduler.instance,
                reducer: @escaping (Request) -> Single<Response>) {
        
        prepareReduce(scheduler: scheduler, reducer: reducer)
    }

    public func dispatch(_ request: Request, force: Bool = false) {
        dispatcher.accept((request, force))
    }
    
    public func asObservable() -> Observable<State> {
        return state.asObservable()
    }
}

extension ResultStateObservable {
    
    private func prepareReduce(
        scheduler: SchedulerType,
        reducer: @escaping (Request) -> Single<Response>) {
        
        let request = dispatcher
            .observeOn(scheduler)
            .map { [state] (request, force) in
                return (request, force, state.value)
            }.filter { (_, force, state) in
                force || !state.isLoading
            }.share(replay: 1)
        
        let onLoad = request.flatMap { (_, force, state) -> Observable<State> in
            if force && state.isLoading { return .empty() }
            return .just(.loading)
        }
        
        let onResult = request.flatMapLatest { (request, _, _) -> Observable<State> in
            reducer(request)
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

extension ResultStateObservable where Request == Void {
    
    public func dispatch(force: Bool = false) {
        dispatcher.accept(((), force))
    }
}
