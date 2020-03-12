//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define search API ✅
 2. Define SearchResultsObservable ✅
 3. Define State of SearchResultsObservable
 4. Update actions and add dispatcher
 5. Prepare action binding
 6. Prepare state update
 7. Prepare side effect
 
*/

final class SearchResultsObservable: ObservableConvertibleType {

    struct State {
    }
    
    private let api: SearchAPI
    private let state: BehaviorRelay<State>
    
    var current: State { return state.value }
    
    init(api: SearchAPI) {
        self.api = api
        self.state = .init(value: State())
    }

    func asObservable() -> Observable<State> {
        return state.asObservable()
    }
    
}

//: [Next](@next)
