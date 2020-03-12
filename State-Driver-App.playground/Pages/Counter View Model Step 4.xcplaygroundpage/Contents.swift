//: [Previous](@previous)

/*:
 
 ### Integration of CounterObservable in ViewModel
 
 1. Define inputs ✅
 2. Define outputs ✅
 3. Setup inputs with CounterObservable ✅
 4. Setup outputs with CounterObservable ✅
 5. Connect to input and output
*/

import RxSwift

final class CounterViewModel {
    
    struct Input {
        var increment: Binder<Void>
        var decrement: Binder<Void>
    }
    
    struct Output {
        var current: Driver<String>
    }
    
    let input: Input
    let output: Output
    
    init(state: CounterObservable) {
        
        // Input
        let increment = Binder<Void>(state, binding: { (state, _) in state.increment() })
        let decrement = Binder<Void>(state, binding: { (state, _) in state.decrement() })
        
        // Output
        let current = state
            .asObservable()
            .map { "Counter: \($0)" }
            .asDriver(onErrorDriveWith: .empty())
    }
    
}


//: [Next](@next)
