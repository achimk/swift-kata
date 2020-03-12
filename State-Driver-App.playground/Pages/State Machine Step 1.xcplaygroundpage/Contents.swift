//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define states ✅
 2. Define actions (transitions)
 3. Define transitions
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
    
}


//: [Next](@next)
