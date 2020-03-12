//: [Previous](@previous)

/*:
 
 ### Sample of using Observable Convertible Protocol

 1. Apply ObservableConvertibleType ✅
 2. Add default state
 3. Add state modifiers and accessors
*/

import RxSwift

final class CounterObservable: ObservableConvertibleType {
    
    func asObservable() -> Observable<Int> {
        // ...
    }
}

//: [Next](@next)
