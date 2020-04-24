//
//  Created by Joachim Kret on 21/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreKit

public typealias ActivityState<Success, Failure> = ResultState<Success, Failure>

open class ActivityStateIndicator<Value>: ObservableConvertibleType {

    public typealias State = ResultState<Value, Error>

    private let dispatcher = PublishRelay<Bool>()
    private let state = BehaviorRelay<State>(value: .initial)
    private var bag = DisposeBag()

    public var current: State { return state.value }

    public init(scheduler: SchedulerType = MainScheduler.instance,
                reducer: @escaping () -> Single<Value>) {

        prepareReduce(scheduler: scheduler, reducer: reducer)
    }

    public func dispatch(force: Bool = false) {
        dispatcher.accept(force)
    }

    public func asObservable() -> Observable<State> {
        return state.asObservable()
    }

    private func prepareReduce(
        scheduler: SchedulerType,
        reducer: @escaping () -> Single<Value>) {

        let request = dispatcher
            .observeOn(scheduler)
            .map { [state] (force) in
                return (force, state.value)
            }.filter { (force, state) in
                force || !state.isLoading
            }.share(replay: 1)

        let onLoad = request.flatMap { (force, state) -> Observable<State> in
            if force && state.isLoading { return .empty() }
            return .just(.loading)
        }

        let onResult = request.flatMapLatest { (_) -> Observable<State> in
            return reducer()
                .asObservable()
                .map { State.success($0) }
                .catchError { .just(State.failure($0)) }
        }

        Observable
            .merge(onLoad, onResult)
            .observeOn(scheduler)
            .bind(to: state)
            .disposed(by: bag)
    }
}
