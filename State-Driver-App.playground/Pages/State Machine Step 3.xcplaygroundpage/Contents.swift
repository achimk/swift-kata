//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define states ✅
 2. Define actions (transitions) ✅
 3. Define transitions ✅
 4. Wrap to ObservableConvertibleType
 
*/

final class SearchState {
    
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
    
    private var state: State = .start
    
    var current: State { return state.value }
    
    init() { }
    
    func dispatch(_ action: Action) {
        switch (current, action) {
        case (.start, .startSearch): state = .searching
        case (.searching, .search): state = .loading
        case (.searching, .cancel): state = .start
        case (.loading, .success): state = .searchResults
        case (.loading, .failure): state = .error
        case (.searchResults, .startSearch): state = .searching
        case (.error, .startSearch): state = .searching
        default: return
        }
    }
    
}


//: [Next](@next)
