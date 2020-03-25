//
//  Created by Joachim Kret on 24/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa

final class SignalToSignalTests: XCTestCase {
    
    final class EventSink<T> {
        
        private var consumers: [(T) -> ()] = []
        
        func dispatch(_ event: T) {
            consumers.forEach { $0(event) }
        }
        
        func add(_ consumer: @escaping (T) -> ()) {
            consumers.append(consumer)
        }
        
    }
    
    final class FirstViewModel {
        
        enum Event {
            case formPresented
            case progressPresented
            case reservationCreated
            case reservationUpdated
            case reservationRemoved
            case reservationDiscrarded
        }
        struct Input {
            //...
        }
        struct Output {
            //...
        }
        
        let input: Input = Input()
        let output: Output = Output()
        
        private let eventConsumer: (Event) -> ()
        
        init(eventConsumer: @escaping (Event) -> ()) {
            self.eventConsumer = eventConsumer
            //...
        }
    }
    
    final class SecondViewModel {
        
        struct Event {
            var formPresented: Signal<Void> = .never()
            var progressPresented: Signal<Void> = .never()
            var reservationCreated: Signal<Void> = .never()
            var reservationUpdated: Signal<Void> = .never()
            var reservationRemoved: Signal<Void> = .never()
            var reservationDiscrarded: Signal<Void> = .never()
        }
        struct Input {
            //...
        }
        struct Output {
            //...
        }
        
        let event: Event = Event()
        let input: Input = Input()
        let output: Output = Output()
        
        init() {
            //...
        }
    }
    
    final class ThirdViewModel {
        
        enum Wireframe {
            case reservationCreated
            case reservationUpdated
            case reservationRemoved
            case reservationDiscrarded
        }
        
        enum AnalyticsEvent {
            case formPresented
            case progressPresented
        }
        
        struct Input {
            //...
        }
        struct Output {
            //...
        }
        
        let input: Input = Input()
        let output: Output = Output()
        
        init(wireframe: (Wireframe) -> (), analytics: (AnalyticsEvent) -> ()) {
            //...
        }
    }
    
    private var bag = DisposeBag()
    
    override func tearDown() {
        bag = DisposeBag()
    }
    
    func testMe() {
        
        let publisher = PublishRelay<Int>()
        let signal = publisher.asSignal()
        
        let anotherPublisher = PublishRelay<Int>()
        let anotherSignal = anotherPublisher.asSignal()
        
        var results: [Int] = []
        anotherSignal.emit(to: publisher).disposed(by: bag)
        signal.emit(onNext: { results.append($0) }).disposed(by: bag)
        
        anotherPublisher.accept(1)
        anotherPublisher.accept(2)
        anotherPublisher.accept(3)
        
        expect(results) == [1, 2, 3]
    }
    
    func testSecondViewModel() {
        
        let viewModel = SecondViewModel()
        
        viewModel.event.reservationCreated.emit(onNext: { })
        viewModel.event.reservationUpdated.emit(onNext: { })
    }
}
