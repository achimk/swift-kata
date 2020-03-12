//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define states ✅
 2. Define actions (transitions) ✅
 3. Define transitions ✅
 4. Wrap to ObservableConvertibleType ✅
 
*/

final class SearchStateObservable: ObservableConvertibleType {
    
    enum State {
        case start
        case searching
        case loading
        case searchResults
        case error
    }
    
    enum Action {
        case startSearch
        case cancel
        case search
        case success
        case failure
    }
    
    private let state = BehaviorRelay<State>(value: .start)
    
    var current: State { return state.value }
    
    init() { }
    
    func dispatch(_ action: Action) {
        switch (current, action) {
        case (.start, .startSearch): state.accept(.searching)
        case (.searching, .search): state.accept(.loading)
        case (.searching, .cancel): state.accept(.start)
        case (.loading, .success): state.accept(.searchResults)
        case (.loading, .failure): state.accept(.error)
        case (.searchResults, .startSearch): state.accept(.searching)
        case (.error, .startSearch): state.accept(.searching)
        default: return
        }
    }
    
    func asObservable() -> Observable<State> {
        return state.asObservable()
    }

}


//: [Next](@next)
