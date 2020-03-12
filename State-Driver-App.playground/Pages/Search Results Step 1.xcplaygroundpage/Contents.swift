//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define search API ✅
 2. Define SearchResultsObservable
 3. Define State of SearchResultsObservable
 4. Update actions and add dispatcher
 5. Prepare action binding
 6. Prepare state update
 7. Prepare side effect
 
*/

typealias SearchItem = String

protocol SearchAPI {
    func search(for text: String) -> Single<[SearchItem]>
}

//: [Next](@next)
