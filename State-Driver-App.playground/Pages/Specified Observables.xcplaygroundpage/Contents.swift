//: [Previous](@previous)

/*:
 
 ### Specified Observables in RxSwift
   
*/

/*:
 ### PublishSubject<T>
 * Represents an object that is both an observable sequence as well as an observer.
*/

final class PublishSubject<T> {
    
    //...
    
    public func on(_ event: Event<Element>) {
        //...
    }
    
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        //...
    }
    
    //...
}

/*:
 ### BehaviourSubject<T>
 * Observers can subscribe to the subject to receive the last (or initial) value and all subsequent notifications.
*/

final class BehaviourSubject<T> {
    
    //...
    
    public func value() throws -> Element {
        //...
    }
    
    public func on(_ event: Event<Element>) {
        //...
    }
    
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        //...
    }
    
    // ...
}

/*:
 ### PublishRelay<T>
 * PublishRelay is a wrapper for `PublishSubject`.
 * Unlike `PublishSubject` it can't terminate with error or completed.
*/

final class PublishRelay<Element>: ObservableType {
    private let _subject: PublishSubject<Element>
    
    // Accepts `event` and emits it to subscribers
    func accept(_ event: Element) {
        self._subject.onNext(event)
    }

    /// Subscribes observer
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }
    
    /// - returns: Canonical interface for push style sequence
    func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}

/*:
 ### BehaviourRelay<T>
 * BehaviorRelay is a wrapper for `BehaviorSubject`.
 * Unlike `BehaviorSubject` it can't terminate with error or completed.
*/
final class BehaviorRelay<Element>: ObservableType {
    private let _subject: BehaviorSubject<Element>

    /// Accepts `event` and emits it to subscribers
    func accept(_ event: Element) {
        self._subject.onNext(event)
    }

    /// Current value of behavior subject
    var value: Element {
        // this try! is ok because subject can't error out or be disposed
        return try! self._subject.value()
    }

    /// Subscribes observer
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}


//: [Next](@next)
